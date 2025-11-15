import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gyawun/ytmusic/ytmusic.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import 'file_storage.dart';
import 'settings_manager.dart';
import 'stream_client.dart';

Box _box = Hive.box('DOWNLOADS');
YoutubeExplode ytExplode = YoutubeExplode();

class DownloadManager {
  Client client = Client();
  ValueNotifier<List<Map>> downloads = ValueNotifier([]);
  final int maxConcurrentDownloads = 3; // Limit concurrent downloads
  int _activeDownloads = 0;
  final Queue<Map> _downloadQueue = Queue<Map>(); // Queue for pending downloads

  // Throttle progress updates to avoid too many concurrent Hive writes
  final Map<String, Timer?> _progressUpdateTimers = {};
  final Map<String, Map<String, dynamic>> _pendingProgressUpdates = {};

  DownloadManager() {
    downloads.value = _box.values.toList().cast<Map>();
    _box.listenable().addListener(() {
      downloads.value = _box.values.toList().cast<Map>();
    });
  }

  void _scheduleProgressUpdate(String videoId, Map<String, dynamic> data) {
    // Store the latest progress data
    _pendingProgressUpdates[videoId] = data;

    // Cancel existing timer if any
    _progressUpdateTimers[videoId]?.cancel();

    // Schedule a new update after a short delay (throttling)
    _progressUpdateTimers[videoId] = Timer(const Duration(milliseconds: 500), () async {
      final updateData = _pendingProgressUpdates[videoId];
      if (updateData != null) {
        try {
          await _box.put(videoId, updateData);
        } catch (e) {
          print('Error updating progress: $e');
        }
        _pendingProgressUpdates.remove(videoId);
        _progressUpdateTimers.remove(videoId);
      }
    });
  }

  void _cancelProgressUpdates(String videoId) {
    _progressUpdateTimers[videoId]?.cancel();
    _progressUpdateTimers.remove(videoId);
    _pendingProgressUpdates.remove(videoId);
  }

  Future<void> downloadSong(Map song) async {
    final String videoId = song['videoId'];
    final String title = song['title'] ?? 'Unknown';

    if (_activeDownloads >= maxConcurrentDownloads) {
      _downloadQueue.add(song); // Add to queue if limit reached
      print('📥 [QUEUE] Added to queue: $title ($videoId)');
      return;
    }

    print('⏬ [START] Starting download: $title ($videoId)');
    _activeDownloads++;

    try {
      if (!(await FileStorage.requestPermissions())) {
        print('❌ [PERMISSION] Permission denied for: $title');
        _activeDownloads--;
        _downloadNext();
        return;
      }

      print('🔍 [FETCH] Fetching stream info for: $title');
      AudioOnlyStreamInfo audioSource = await _getSongInfo(song['videoId'],
          quality:
              GetIt.I<SettingsManager>().downloadQuality.name.toLowerCase());
      int start = 0;
      int end = audioSource.size.totalBytes;

      print('📡 [STREAM] Starting stream for: $title (${(end / 1024 / 1024).toStringAsFixed(2)} MB)');
      Stream<List<int>> stream = AudioStreamClient()
          .getAudioStream(audioSource, start: start, end: end);
      int total = audioSource.size.totalBytes;
      List<int> received = [];
      await _box.put(song['videoId'], {
        ...song,
        'status': 'PROCESSING',
        'progress': 0,
      });
      stream.listen(
        (data) {
          received.addAll(data);
          // Use throttled update to avoid too many concurrent writes
          _scheduleProgressUpdate(song['videoId'], {
            ...song,
            'status': 'DOWNLOADING',
            'progress': (received.length / total) * 100,
          });
        },
        onDone: () async {
          // Cancel pending progress updates
          _cancelProgressUpdates(videoId);

          print('📦 [COMPLETE] Download completed: $title (${(received.length / 1024 / 1024).toStringAsFixed(2)} MB received)');

          try {
            if (received.length == total) {
              print('💾 [SAVE] Saving file: $title');
              File? file = await GetIt.I<FileStorage>().saveMusic(received, song);
              if (file != null) {
                print('✅ [SUCCESS] File saved to: ${file.path}');
                await _box.put(videoId, {
                  ...song,
                  'status': 'DOWNLOADED',
                  'progress': 100,
                  'path': file.path,
                  'timestamp': DateTime.now().millisecondsSinceEpoch
                });
              } else {
                print('❌ [ERROR] Failed to save file: $title');
                await _box.delete(videoId);
              }
            } else {
              print('⚠️ [WARNING] Incomplete download: $title (${received.length}/$total bytes)');
            }
          } catch (e) {
            print('❌ [ERROR] Error saving file "$title": $e');
          } finally {
            _activeDownloads--;
            print('📊 [STATUS] Active downloads: $_activeDownloads, Queue: ${_downloadQueue.length}');
            _downloadNext(); // Trigger next download
          }
        },
        onError: (err) async {
          // Cancel pending progress updates
          _cancelProgressUpdates(videoId);

          print('❌ [ERROR] Download failed: $title - $err');

          try {
            await _box.delete(videoId);
          } catch (e) {
            print('❌ [ERROR] Error cleaning up after failure "$title": $e');
          } finally {
            _activeDownloads--;
            print('📊 [STATUS] Active downloads: $_activeDownloads, Queue: ${_downloadQueue.length}');
            _downloadNext(); // Trigger next download
          }
        },
      );
    } catch (e) {
      print('❌ [EXCEPTION] Exception during download "$title": $e');
      await _box.delete(videoId); // Handle errors by removing entry
      _activeDownloads--;
      print('📊 [STATUS] Active downloads: $_activeDownloads, Queue: ${_downloadQueue.length}');
      _downloadNext();
    }
  }

  void _downloadNext() {
    if (_downloadQueue.isNotEmpty &&
        _activeDownloads < maxConcurrentDownloads) {
      final nextSong = _downloadQueue.removeFirst();
      print('⏭️ [NEXT] Starting next from queue: ${nextSong['title']} (Queue: ${_downloadQueue.length} remaining)');
      downloadSong(nextSong);
    } else if (_downloadQueue.isEmpty && _activeDownloads == 0) {
      print('🎉 [FINISHED] All downloads completed!');
    }
  }

  Future<String> deleteSong(String key, String path) async {
    await _box.delete(key);
    await File(path).delete();
    return 'Song deleted successfully.';
  }

  updateStatus(String key, String status) {
    Map? song = _box.get(key);
    if (song != null) {
      song['status'] = status;
      _box.put(key, song);
    }
  }

  Future<void> downloadPlaylist(Map playlist) async {
    final String playlistTitle = playlist['title'] ?? 'Unknown Playlist';
    print('📋 [PLAYLIST] Starting playlist download: $playlistTitle');

    List songs =
        await GetIt.I<YTMusic>().getPlaylistSongs(playlist['playlistId']);

    print('📋 [PLAYLIST] Found ${songs.length} songs in: $playlistTitle');

    int skipped = 0;
    int queued = 0;

    for (Map song in songs) {
      // Skip if song is already downloaded, downloading, or processing
      Map? existingSong = _box.get(song['videoId']);
      if (existingSong != null &&
          ['DOWNLOADED', 'DOWNLOADING', 'PROCESSING']
              .contains(existingSong['status'])) {
        skipped++;
        print('⏩ [SKIP] Already ${existingSong['status'].toLowerCase()}: ${song['title']}');
        continue;
      }
      downloadSong(song); // Queue each song download (no await to add all to queue quickly)
      queued++;
    }

    print('📋 [PLAYLIST] Summary - Queued: $queued, Skipped: $skipped, Total: ${songs.length}');
  }

  Future<AudioOnlyStreamInfo> _getSongInfo(String videoId,
      {String quality = 'high'}) async {
    try {
      StreamManifest manifest = await ytExplode.videos.streamsClient
          .getManifest(videoId,
              requireWatchPage: true, ytClients: [YoutubeApiClient.androidVr]);
      List<AudioOnlyStreamInfo> streamInfos = manifest.audioOnly
          .where((a) => a.container == StreamContainer.mp4)
          .sortByBitrate()
          .reversed
          .toList();
      return quality == 'low' ? streamInfos.first : streamInfos.last;
    } catch (e) {
      rethrow;
    }
  }
}

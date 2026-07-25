# Rationale

## State management: Cubit

I used flutter_bloc's Cubit as the ViewModel layer. Each screen has one Cubit (CourseListCubit,
CoursePlayerCubit) that takes use cases as constructor dependencies, exposes an immutable state,
and contains no widget/BuildContext logic. This maps cleanly onto MVVM: Cubit = ViewModel,
screens/widgets = View, use cases + entities = Model. Compared to plain Provider/ChangeNotifier,
Cubit forces state to be represented as explicit, immutable classes (Initial, Loading, Loaded,
Error) rather than mutable fields on a notifier, which makes "what can this screen look like"
enumerable up front.

## Resume playback

Progress is tracked as seconds watched, persisted via SharedPreferences keyed by course id.
CoursePlayerCubit owns the VideoPlayerController end-to-end: it checks connectivity before
creating the controller, asks GetProgress for the saved position on successful init, then
ProgressCalculator.resumePositionSeconds() decides where to actually seek to. If the saved
position is within 2 seconds of the end, it is treated as "finished" and restarts from 0 instead
of resuming right before the video ends. A periodic 3 second timer saves progress while playing
as a safety net for an abrupt app close, and a final save happens when the user navigates back
normally.

Trade-offs: saving every 3 seconds trades a bit of I/O for simplicity over debouncing on
pause/backgrounding. No explicit "completed" flag exists, only a percentage, since the spec left
"what progress means" open.

## Edge case handled

Offline and failed video load. Both CourseListCubit and CoursePlayerCubit check connectivity
before doing anything else, so a disconnected device gets an immediate retry screen instead of a
hanging spinner. Video initialization is wrapped in a 15 second timeout, covering the case where
the network is up but the video URL itself is slow or broken.

## What I would do differently with more time

Debounce progress saves on scrubbing rather than only on a timer. Add a "continue watching"
section or explicit "completed" badge on the list screen. Cache thumbnails instead of re-fetching
them from picsum.photos on every visit. Add a CoursePlayerCubit test with a mock
VideoPlayerController to cover the resume-seek interaction directly, not just the pure
ProgressCalculator math.
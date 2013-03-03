(function() {
	
var getUserMedia = navigator.getUserMedia ||
		navigator.webkitGetUserMedia || navigator.mozGetUserMedia ||
		navigator.msGetUserMedia;

// based on https://gist.github.com/s-shin/4011149
var setupUserMedia = function(media, fn) {
	if (arguments.length == 1) {
		fn = media;
		media = {video: true, audio: true};
	}
		
	if (!getUserMedia)
		return fn("WebRTC is not supported.");
		
	// for legacy
	media.toString = function() {
		var t = [];
		for (var type in media)
			t.push(type);
		return t.join(",");
	};
		
	// call getUserMedia
	getUserMedia.call(navigator, media, function(stream) {
		var video = document.createElement("video");
		if (navigator.mozGetUserMedia) {
			// CAUTION: Many fakes exist ;-(
			// https://developer.mozilla.org/en-US/docs/WebRTC/taking_webcam_photos
			video.mozSrcObject = stream;
		} else {
			var URL = window.URL || window.webkitURL; // need prefix on Webkit
			video.src = URL.createObjectURL(stream);
		}
		// wait a moment because the video size cannot be got immediately (why?)
		video.play(); // need play in order to do that
		setTimeout(function wait() {
			if (video.videoWidth > 0)
				return fn(null, video); // OK, go next
			setTimeout(wait, 20);
		}, 4);
	}, function(err) {
		fn(err);
	});
};

window.UserMedia = {
	isAvailable: function() { return getUserMedia ? true : false },
	setup: setupUserMedia
};

})()




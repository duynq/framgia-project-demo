$(document).ready(function () {
	// auto send comment when enter
	$(document).ready(function() {
		$('.comment_field').keydown(function(event) {
			if (event.keyCode == 13) {
				$(this.form).submit();
				return false;
			}
		});
	});
	$("#entry_picture").bind('change', function () {
		var size_in_megabytes = this.files[0].size/1024/1024;
		if (size_in_megabytes > 5) {
			alert('Maximum file size is 5MB. Please choose a smaller file.');
		}
	})

	// auto load activity
	is_activity_loading=false;

	$(window).scroll(function () {
		//find the visible load more button

		//since bp does not move load more, we need to find the last one which is visible
		var load_more_btn=$("#load-more");

		//if there is no visible button, there are no mor activities, let us retrn
		if(!load_more_btn.get(0))
			return;

		//find the offset of the button
		var pos=load_more_btn.offset();

		//if the window height+scrollTop is greater than the offset top, we have reached the button, let us load more activity
		if($(window).scrollTop() + $(window).height() > pos.top && !is_activity_loading) {	
			is_activity_loading=true;
			$(load_more_btn.find("form")[0]).submit();
		}else {
			// console.log(($(window).scrollTop() + $(window).height() > pos.top) + ' ' + !is_activity_loading)
		}
	});

	setInterval(function () {
		is_activity_loading = false;
	}, 2000);
})
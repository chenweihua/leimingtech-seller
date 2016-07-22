$(function(){
	var nowHref = window.location.pathname+window.location.search;//端口后路径加参数如/test/test.htm?id=1
	$(".sidebar").find("a").each(function(){
		if(nowHref==$(this).attr("href")){
			$(this).addClass("active");
		}else{
			$(this).removeClass();
			$(this).addClass("normal");
		}
	});

});
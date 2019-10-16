
//menu button setting for different medias
if (window.matchMedia('(max-width: 400px)').matches) {
	document.getElementById("menu_icon").style.display= "block";
}

$(document).load($(window).bind("resize", checkPosition));

	function checkPosition()
	{
		if (window.matchMedia('(max-width: 400px)').matches) {
			document.getElementById("menu_icon").style.display= "block";
			document.getElementById("mySidebar").style.width = "0px";
	    }else {
	        $(".closeSideBarButton").css("display:none");
	        document.getElementById("mySidebar").style.width = "150px";
            document.getElementById("mySidebar").style.transform= "0.6s";
	        document.getElementById("closeSection").style.display = "none";
	        document.getElementById("menu_icon").style.display= "none";
	    }

	}

//opening side bar
function opensidebar(){
	if (window.matchMedia('(max-width: 400px)').matches)
	{
		document.getElementById("mySidebar").style.width = "100px";
		document.getElementById("closeSection").style.display = "block";
	}
}

//closing side bar
function closeSideBar()
{
   document.getElementById("mySidebar").style.width = "0px";                                        
}



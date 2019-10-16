<%-- 
    Document   : manageGroups
    Created on : 12 Oct, 2019, 8:08:59 PM
    Author     : elkorf
--%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page import="db.Dbconn"%>
<%@page import="java.sql.ResultSet"%>
<%@include file="sessioncheck.jsp" %>
<html>
<head>
    <title>Manage Groups</title>
<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<meta name="viewport" content="width=device-width,initial-scale=1">
	<meta name="description" content="">
	<meta name="author" content="">

	<!-- Fonts -->
 	<link href="lib/font/montserrat.css" rel="stylesheet" type="text/css">
  	<link href="lib/font/lato.css" rel="stylesheet" type="text/css">
  	
  	<!--Bootstrap-->
  	<link rel="stylesheet" href="lib/bootstrap/css/bootstrap.min.css">

	<!--Css-->
	<link rel="stylesheet" href="css/dashboard.css">
      	<link rel="stylesheet" href="css/statistics.css">

</head>
<body id="page-top">

<!--Navigation bar-->
	<nav class="navbar navbar-expand navbar-dark bg-dark fixed-top">
		<div id="menu_icon">
		<a href="#home"  class="navbar-brand mr-1" onclick="opensidebar()"><img src="img/menu_icon1.png" style="height:20px;width:20px"></img></a>
		</div>                                                        
	    <a class="navbar-brand mr-1" href="home.jsp">#SIGMS</a>
		<!-- Navbar Search -->
		<form class="d-none d-md-inline-block form-inline ml-auto mr-md-3 my-md-0" style="visibility:hidden;">
		    <div class="input-group">
				<input type="text" class="form-control" placeholder="Search for..." aria-label="Search" aria-describedby="basic-addon2" style="font-size:12px;width: 200px;">
				<div class="input-group-append">
			  		<button class="btn btn-primary" type="button">
			    		<span class="glyphicon glyphicon-search"></span>
			  		</button>
				</div>
		    </div>
		</form>

    <!-- Navbar -->
    <ul class="navbar-nav ml-auto ml-md-0">
	    <li style="visibility:hidden;">
                    <a class="nav-link dropdown-toggle" href="#" id="alertsDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            <span class="badge badge-success">9+</span>
                    </a>
                    <div class="dropdown-menu dropdown-menu-right" aria-labelledby="alertsDropdown">
                      <a class="dropdown-item" href="#">Action</a>
                      <a class="dropdown-item" href="#">Another action</a>
                      <div class="dropdown-divider"></div>
                      <a class="dropdown-item" href="#">Something else here</a>
                    </div>
            </li>
            <li class="nav-item dropdown" style="visibility:hidden;">
                    <a class="nav-link dropdown-toggle" href="#" id="messagesDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                      <span class="badge badge-danger">7+</span>
                    </a>
                    <div class="dropdown-menu dropdown-menu-right" aria-labelledby="messagesDropdown">
                      <a class="dropdown-item" href="#">Action</a>
                      <a class="dropdown-item" href="#">Another action</a>
                      <div class="dropdown-divider"></div>
                      <a class="dropdown-item" href="#">Something else here</a>
                    </div>
            </li>
            <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            <span class="badge badge-danger">Profile</span>
                    </a>
                    <div class="dropdown-menu dropdown-menu-right" aria-labelledby="userDropdown">	
                      <a class="dropdown-item" href="#">Settings</a>
                      <a class="dropdown-item" href="#">Activity Log</a>
                      <div class="dropdown-divider"></div>
                      <a class="dropdown-item" href="logout.jsp">Logout</a>
                    </div>
            </li>
	</ul>
	</nav>

<%
    //the following block of code sets the sigid as a session varibale to use it to access a perticlar sig handels corner cases
    try{
        String sigid = (session.getAttribute("sigid") != null) ? session.getAttribute("sigid").toString() : null;
        String parameter = (request.getParameter("sigid") != null) ? request.getParameter("sigid").toString() : "null";
        if(!parameter.equals("null"))
            session.setAttribute("sigid", parameter);
    }catch(Exception e){
        System.out.println("Exception Occured while setting group id as session variable on group posts page: "+e.toString());
    }
%>	

<!----------Side bar----------------->

		
<div class="sidebar bg-dark" id="mySidebar"> 						<!--C-->
  <div class="closeSideBarButton" id="closeSection">
      <button onclick="closeSideBar()" style="float:right;background:grey;border:0;radius:30">x</button>   
  </div>										<!--C-->
  <a href="home.jsp" id="home" class="active">Home</a>
  <a href="newSigs.jsp" id="newSigs">SIGs</a>
  <a href="mySigs.jsp" id="mySigs">My SIGs</a>
  <%
      String sig = (session.getAttribute("sigid") != null) ? session.getAttribute("sigid").toString() : "null";
      if(!sig.equals("null"))
      {
  %>
        <a href="groupDashboard.jsp"><%=session.getAttribute("sigid")%></a>
  <%
      }
  %>
  <a href="newEvents.jsp" id="newEvents">Events</a>
  <a href="myContributions.jsp" id="myContributions">My Contributions</a>
  
</div>

<!---------------------------------content -------------------------------->
<div class="content">
    <%@include file="messages.jsp"%>   

<!--Group Manage Section-->
<div class="text-center" style="width:100%;">
    <a style="width:20%;" class="btn btn-lg btn-info" href="manageAdmins.jsp">
        Manage Admins
    </a>
    <a style="width:20%;" class="btn btn-lg btn-info" href="#">
        Manage Users
    </a>
    <a style="width:20%;" class="btn btn-lg btn-info" href="#">
        Create Groups
    </a>
    <a style="width:20%;" class="btn btn-lg btn-info" href="#">
        Manage Groups
    </a>
</div>    
<hr> 
<%
//rest of the page
    ResultSet rsgrp = null;
    
    try{
        //CONNECTING DATABASE
        Dbconn db=new Dbconn();
        Connection con =db.connect();
        
        Statement st = con.createStatement();
    
        
        rsgrp = st.executeQuery("select * from group_details where group_id = '"+session.getAttribute("sigid")+"' ");
        if(!rsgrp.next())   //if there is nothing in resultset that mens there is no such sig
        {
            session.setAttribute("alert_message","You are trying to access a sig that doesnt exist!");
            session.setAttribute("alert_type","warning");
            response.sendRedirect("home.jsp");
        }else{
 
%>
<!--Group name and Description-->
<div class="jumbotron">
    <div class="row align-items-center">
    	<div class="float-left clear-left" style="margin-right: 15px; max-width: 100%;" onblur="saveGrpName();"  id='grpname'>
            <h1><%=rsgrp.getString("group_name")%></h1>
        </div>
        <div class="btn btn-light" onclick="editGrpName()" >
            <img src='img/edit-solid.svg' style='width: 30px;height: 30px;'>
        </div>    
    </div>    
    <hr>
    <div class="text-center">
    	<h3>Description</h3><br>		
    </div>
    <div class="col-md-12 border border-info" >
        <div>
            <p onblur="saveDesription()" style="max-width: 100%; padding-left:5px;padding-right: 5px;" id="description">
                <%=rsgrp.getString("description")%>
            </p>
        </div>
        <div>
            <center>
                <div class="row btn btn-lg btn-success" onclick="editDesription()">
                    Edit
                </div>
                <div class="row btn btn-lg btn-success " onclick="submitThis()">
                    Save
                </div>    
            </center>
        </div>
                <br>
    </div>    
</div



<!-- end of content section-->
</div>
            
<script src="js/sidebar_size.js"></script>
<script src="js/manageGroups.js"></script>
<script src="lib/jquery/jquery.min.js"></script>
<script src="lib/bootstrap/js/bootstrap.min.js"></script>


<%
           
        }
    }catch(Exception ex){
            System.out.println("Exception on manage grp : "+ex);
    }

%>
</body>
</html>     
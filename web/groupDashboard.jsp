<%@page import="java.sql.CallableStatement"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page import="db.Dbconn"%>
<%@page import="java.sql.ResultSet"%>
<%@include file="sessioncheck.jsp" %>
<html>
<head>
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
        <link rel="stylesheet" href="css/counters.css">
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
  <a href="home.jsp" id="home">Home</a>
  <a href="newSigs.jsp" id="newSigs" >SIGs</a>
  <a href="mySigs.jsp" id="mySigs">My SIGs</a>
  <%
      String sig = (session.getAttribute("sigid") != null) ? session.getAttribute("sigid").toString() : "null";
      if(!sig.equals("null"))
      {
  %>
        <a href="groupDashboard.jsp" class="active"><%=session.getAttribute("sigid")%></a>
  <%
      }
  %>
  <a href="newEvents.jsp" id="newEvents">Events</a>
  <a href="myContributions.jsp" id="myContributions">My Contributions</a>
  
</div>
<!---------------------------------content -------------------------------->
<%
    
    //rest of the page
    ResultSet rsgrp = null, rscount = null;
    String mem = null , post = null , eve = null , que = null;
    try{
        //CONNECTING DATABASE
        Dbconn db=new Dbconn();
        Connection con =db.connect();
        
        Statement st = con.createStatement();
        Statement st2 = con.createStatement();
        
        rsgrp = st.executeQuery("select * from group_details where group_id = '"+session.getAttribute("sigid")+"' ");
        if(!rsgrp.next())   //if there is nothing in resultset that mens there is no such sig
        {
            session.setAttribute("alert_message","You are trying to access a sig that doesnt exist!");
            session.setAttribute("alert_type","warning");
            response.sendRedirect("home.jsp");
        }else{
            
            //get no of questions
            rscount = st2.executeQuery("select count(*) as qcount from questions where group_id = '"+session.getAttribute("sigid")+"' ");
            rscount.next();
            que = rscount.getString("qcount");
            rscount = null;
            
            //get no of posts
            rscount = st2.executeQuery("select count(*) as pcount from post where group_id = '"+session.getAttribute("sigid")+"' ");
            rscount.next();
            post = rscount.getString("pcount");
            rscount = null;
            
            //get no of events
            rscount = st2.executeQuery("select count(*) as ecount from event where group_id = '"+session.getAttribute("sigid")+"' ");
            rscount.next();
            eve = rscount.getString("ecount");
            rscount = null;
            
            //get no of members
            rscount = st2.executeQuery("select count(*) as mcount from group_members where group_id = '"+session.getAttribute("sigid")+"' ");
            rscount.next();
            mem = rscount.getString("mcount");
            rscount = null;
        
        
%>

<div class="content">
    <%@include file="messages.jsp"%>
<div id="banner" style="background:#d8e3e9;  padding-top:0.7vh">
    <div style="height: 50px;">
        <div>
            <h2 class="text-center"><%=rsgrp.getString("group_name").toUpperCase()%></h2>
        </div>
    </div>
</div>
<hr>
<!--floating buttons-->
<%
    if(session.getAttribute("uid").toString().equals(rsgrp.getString("created_by"))){
%>
<button type="button" onclick="location.href = 'manageGroups.jsp?sigid=<%=session.getAttribute("sigid")%>'" style="top:74vh;" class="hoverbtn btn btn-success shadow-lg p-3 mb-5 rounded" >
  Manage Group
</button>
<%}%>
<button type="button" onclick="location.href = 'groupContentPosts.jsp';" style="top:82vh;" class="hoverbtn btn btn-info shadow-lg p-3 mb-5 rounded" >
  Enter Group
</button>
<%
    //check if user is already membe of that group if not give join option
    String query = "{ call isMember(?,?) }";
    CallableStatement callst = con.prepareCall(query);  //for answers

    //set parameters
    callst.setString(1, session.getAttribute("uid").toString());
    callst.setString(2, rsgrp.getString("group_id"));

    //execute call
    ResultSet rsans = callst.executeQuery();

   if(rsans.next() && (!session.getAttribute("uid").toString().equals(rsgrp.getString("created_by")) )){
%>
<button type="button" onclick="location.href = 'LeaveGroup?sigid=<%=session.getAttribute("sigid").toString()%>&uid=<%=session.getAttribute("uid").toString()%>';" style="top:90vh;" class="hoverbtn btn btn-danger shadow-lg p-3 mb-5 rounded" >
  Leave Group
</button>
<%
    }else if(!session.getAttribute("uid").toString().equals(rsgrp.getString("created_by"))){
%>
<button type="button" onclick="location.href = 'JoinGroup?sigid=<%=rsgrp.getString("group_id")%>';" style="top:90vh;" class="hoverbtn btn btn-success shadow-lg p-3 mb-5 rounded" >
  Join Group    
</button>
<%
    }
%>
<div class="row ">
    <div class="col-sm-3">
        <div class="countergreen card shadow bg-white rounded features-card">
            <div class="card-body text-center text-bold">
                <h1 class="text-center" style="font-size: 150px"><%=mem%></h1>
                <h4 class="card-footer">Members</h4>
            </div>
        </div>
    </div><div class="col-sm-3">
        <div class="countercyan card shadow bg-white rounded features-card">
            <div class="card-body text-center text-bold">
                <h1 class="text-center" style="font-size: 150px"><%=post%></h1>
                <h4 class="card-footer">Posts Made</h4>
            </div>
        </div>
    </div>
    <div class="col-sm-3">
        <div class="counterorange card shadow bg-white rounded features-card">
            <div class="card-body text-center text-bold">
                <h1 class="text-center" style="font-size: 150px"><%=que%></h1>
                <h4 class="card-footer">Questions Asked</h4>
            </div>
        </div>
    </div>
    <div class="col-sm-3">
        <div class="counterpink card shadow bg-white rounded features-card">
            <div class="card-body text-center text-bold">
                <h1 class="text-center" style="font-size: 150px"><%=eve%></h1>
                <h4 class="card-footer">Events Organized</h4>
            </div>
        </div>
    </div>
</div>
<hr>
<!--Group Description-->
<div class="row ">
    <div class="col-sm-12">
        <div class="card shadow bg-white rounded features-card">
            <div class="card-header text-center text-bold">
                <h4 class="card-title">Description</h4>    
            </div>
            <div class="card-body text-bold">
                <h3><%=rsgrp.getString("description")%></h3>    
            </div>
            <div class="card-footer text-muted">
                Created on : <%=rsgrp.getString("date_created")%> <br>
                Created on : <%=rsgrp.getString("created_by")%>
            </div>
        </div>
    </div>  
    </div>
<%
        }
    }catch(Exception ex){
        System.out.println("Execption occured while setting up group details page: "+ex.toString());
    }
%>
<!-- end of content section-->
</div>
<script src="js/sidebar_size.js"></script>                                            
<script src="lib/jquery/jquery.min.js"></script>
<script src="lib/bootstrap/js/bootstrap.min.js"></script>
</body>
</html>
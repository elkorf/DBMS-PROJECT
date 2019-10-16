<%-- 
    Document   : mySigs
    Created on : 2 Oct, 2019, 1:18:03 AM
    Author     : elkorf
--%>
<%@include file="sessioncheck.jsp" %>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page import="db.Dbconn"%>
<%@page import="java.sql.ResultSet"%>
<html>
<head>
    <title>My SIGs</title>
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
        <link rel="stylesheet" href="css/newSigs.css">
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

		

<!----------Side bar----------------->

		
<div class="sidebar bg-dark" id="mySidebar"> 						<!--C-->
  <div class="closeSideBarButton" id="closeSection">
      <button onclick="closeSideBar()" style="float:right;background:grey;border:0;radius:30">x</button>   
  </div>										<!--C-->
  <a href="home.jsp" id="home">Home</a>
  <a href="newSigs.jsp" id="newSigs">SIGs</a>
  <a href="mySigs.jsp" id="mySigs" class="active">My SIGs</a>
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

<!--------------------------------------content -------------------------------->
<div class="content">
<div class="text-center">
<%
    try{
        //CONNECTING DATABASE
        Dbconn db=new Dbconn();
        Connection con =db.connect();
    
        ResultSet rs = null;
        ResultSet rs2 = null;
        Statement st = con.createStatement();
        Statement st2 = con.createStatement();
        
        String query = "Select * from `group_details` where group_id in (Select group_id from `group_members` where user_id = '"+session.getAttribute("uid").toString()+"')";
        rs = st.executeQuery(query);
        
        while(rs.next())
        {
            rs2 = st2.executeQuery("select count(*) as count from `group_members` where group_id = '"+rs.getString("group_id")+"' ");
            rs2.next();
        %>
            <div class='card'>
            <div class="card-header col-md-12 text-left">
                    text created time and other stuffs
            </div>
            <div class="col-md-12">  
                <div class="panel panel-default row card-text">
                    <div class="panel-heading col-md-4">
                        <h1 class="text-uppercase"><%=rs.getString("group_name")%></h1>
                        <div class="text-muted text-capitalize">
                            <h3>Created By : <%=rs.getString("created_by")%></h3>
                            <h4>Total Members : <%=rs2.getString("count")%></h4>
                        </div>
                    </div>
                    <div class="panel-body col-md-4">
                        <%=rs.getString("description")%>
                    </div>
                    <div class="panel-footer col-md-4 text-center">
                        <a href="groupContentPosts.jsp?sigid=<%=rs.getString("group_id")%>" class="btn btn-lg" >Open</a>
                        <a href="groupDashboard.jsp?sigid=<%=rs.getString("group_id")%>" class="btn btn-lg" >Details</a>
                    </div>     
                </div>
             </div>             
            <div class="card-footer col-md-12 text-left">
                    Created on: <%=rs.getString("date_created")%>
            </div>            
        </div>
        <%
        }
        
        con.close();
    }catch(Exception ex){
        System.out.println("Exception occured while fetching sigs of user: "+ex.toString());
        response.sendRedirect("logout.jsp");
    }
%>
</div>
<!-- end of content section-->
</div>
<script src="js/sidebar_size.js"></script>                                          	
<script src="lib/jquery/jquery.min.js"></script>
<script src="lib/bootstrap/js/bootstrap.min.js"></script>
</body>
</html>
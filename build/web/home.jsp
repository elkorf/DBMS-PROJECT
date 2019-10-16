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
<%

    ResultSet rscount = null,rsstat = null;
    String grps = null , members = null , events = null , eventsdone = null;
    String grplist[] = new String[6];
    int vals[] = new int[6];
    
    
    try{
    
        //connecting database
        Dbconn db = new Dbconn();
        Connection con = db.connect();
        
        Statement st = con.createStatement();
        
        String usrcnt = "{call usercount()}";
        String evcnt = "{call eventcount()}";
        String grpscnt = "{call groupcount()}";
        
        
        CallableStatement callst = con.prepareCall(usrcnt);
        CallableStatement callst2 = con.prepareCall(evcnt);
        CallableStatement callst3 = con.prepareCall(grpscnt);
        
        //grp count
        rscount = callst3.executeQuery();
        rscount.next();
        grps = rscount.getString("noOfGroups");
        rscount = null;
        //member count
        rscount = callst.executeQuery();
        rscount.next();
        members = rscount.getString("noOfUsers");
        rscount = null;
        //event count
        rscount = callst2.executeQuery();
        rscount.next();
        events = rscount.getString("noOfEvents");
        rscount = null;
        //done event count
        rscount = st.executeQuery("select count(*) as evcnt2 from event where date<now() ");
        rscount.next();
        eventsdone = rscount.getString("evcnt2");
        rscount = null;
        
        //get stat of users joint in last 3 weeks;
        rsstat = st.executeQuery("select group_id,count(*) as count from event group by group_id order by count DESC limit 6");
        
        int i=0;
        while(rsstat.next())
        {
            grplist[i] = rsstat.getString("group_id").toString();
            vals[i++] = rsstat.getInt("count");
        }


%>



<div class="content">
    <%@include file="messages.jsp"%>
    
    <!--this displays the counts of various entities in system-->
    
<div class="row ">
    <div class="col-sm-3">
        <div class="counterpink card shadow bg-white rounded features-card">
            <div class="card-body text-center text-bold">
                <h1 class="text-center" style="font-size: 150px"><%=grps%></h1>
                <h4 class="card-footer">Active Groups</h4>
            </div>
        </div>
    </div><div class="col-sm-3">
        <div class="countergreen card shadow bg-white rounded features-card">
            <div class="card-body text-center text-bold">
                <h1 class="text-center" style="font-size: 150px"><%=members%></h1>
                <h4 class="card-footer">Active Members</h4>
            </div>
        </div>
    </div>
    <div class="col-sm-3">
        <div class="counterorange card shadow bg-white rounded features-card">
            <div class="card-body text-center text-bold">
                <h1 class="text-center" style="font-size: 150px"><%=events%></h1>
                <h4 class="card-footer">Events Posted</h4>
            </div>
        </div>
    </div>
    <div class="col-sm-3">
        <div class="countercyan card shadow bg-white rounded features-card">
            <div class="card-body text-center text-bold">
                <h1 class="text-center" style="font-size: 150px"><%=eventsdone%></h1>
                <h4 class="card-footer">Events Conductedted</h4>
            </div>
        </div>
    </div>
</div>
<hr>

    <!--for displaying graphs of groups-->

<div class="row">
	<div class="col-sm-12 text-center">
		<h5>Stat</h5>		
	</div>
</div>
<br>
<center>
<div>
    <div style="padding-bottom: 2vh;">
        <div class="card shadow bg-white rounded stat-card">
            <div class="card-body text-center text-bold">
                <h4 class="card-title">Groups Statistics</h4>
               
                        <canvas id="myChart"> </canvas>
                   
            </div>
            <div class="card-footer text-muted">
                Groups with most events planned
            </div>
        </div>
    </div>
</div>
<br>
<!-- end of content section-->
</div>
<script src="js/sidebar_size.js"></script>                                            
<script src="lib/jquery/jquery.min.js"></script>
<script src="lib/bootstrap/js/bootstrap.min.js"></script>
<script src="js/Chart.js"></script>

<script>
var ctx = document.getElementById('myChart').getContext('2d');
var myChart = new Chart(ctx, {
    type: 'line',
    data: {
        labels: ['<%=grplist[1]%>', '<%=grplist[3]%>', '<%=grplist[4]%>','<%=grplist[5]%>','<%=grplist[0]%>','<%=grplist[2]%>'],

        datasets: [{

            label: 'Events Planned In Group',
            data: [<%=vals[1]%>, <%=vals[3]%>, <%=vals[4]%>,<%=vals[5]%>,<%=vals[0]%>,<%=vals[2]%>],
            borderWidth: 2,
            borderColor: ['Red', 'Blue', 'Yellow','Green','Cyan','Pink'],
            hoverBorderColor: ['Red', 'Blue', 'Yellow','Green','Cyan','Pink'],
            hoverBackgroundColor: ['Red', 'Blue', 'Yellow','Green','Cyan','Pink']
        }]
    },
   
});
</script>

<%
            
    }catch(Exception ex){
        
        System.out.println("Exception on home: "+ex);
        ex.printStackTrace();
    }
%>
</body>
</html>     
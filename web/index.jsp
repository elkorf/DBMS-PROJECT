
<%@page import="db.Dbconn"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <!-- SIGs -->
  <title>SIGs</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="lib/bootstrap/css/bootstrap-3.4.0.min.css">
  <script src="lib/jquery/jquery.min.js"></script>
  <link rel="stylesheet" type="text/css" href="css/main.css">
  <link rel="stylesheet" type="text/css" href="css/login.css">
  
<!---------------------Scripts---------------------------------------------------->
<script type="text/javascript" src="js/main.js"></script>
<script src="lib/bootstrap/js/bootstrap-3.4.0.min.js"></script>
  

</head>

<body id="myPage" data-spy="scroll" data-target=".navbar" data-offset="60">
    <%
        Dbconn db=new Dbconn();
        Connection con =db.connect();
        try{
        
        Statement st=con.createStatement();
        String getGroups = "SELECT group_name FROM group_details order by date_created desc";
        ResultSet rs=st.executeQuery(getGroups);
    %>
<section>
  <nav class="navbar navbar-default navbar-fixed-top">
  <div class="container">
    <div class="navbar-header">
      <a class="navbar-brand" href="home.jsp">SIGs</a>
    </div>
    <div class="collapse navbar-collapse" id="myNavbar">
      <ul class="nav navbar-nav navbar-right">
        <li><a href="#myPage">HOME</a></li>
        <li><a href="#groups">GROUPS</a></li>
        <li><a href="#statistics">STATISTICS</a></li>
        <li><a href="#contact">CONTACT</a></li>
      </ul>
    </div>
  </div>
</nav>
    
<div class="jumbotron text-center ">
    
                <%@include file="messages.jsp"%> 
  <h1>Special Interest Groups</h1> 
  <p>Explore your special interest here...</p>
  <div>
    <button class="btn btn-lg" style="width: 130px;background: black;margin-right: 5px;border: 2px solid white;" data-toggle="modal" data-target="#signup">Join</button>
    <button class="btn btn-lg" style="width: 130px;background: white;margin-left: 5px; color:black;border: 2px solid white;" data-toggle="modal" data-target="#login">Log in</button>
  </div>
</div>
</section>
<!-- Container (groups Section) -->
<section id="groups" class="container-fluid text-center bg-grey">
  <h2>groups</h2> 
    
    <!-- Wrapper for slides -->
<div style="width: 100%;">
<div style="width: 10%;float:left;">
    <a class="left carousel-control" style="margin-top: 670px;" href="#myCarousel" role="button" data-slide="prev">
    <span><i class="left" aria-hidden="true"></i></span>
    <span class="sr-only">Previous</span>
</a>
</div> 
<div style="width: 80%; margin-left: 10%;overflow-y: scroll; height:400px; ">   
<div id="myCarousel" class="carousel slide text-center" data-ride="carousel">
  <div class="carousel-inner" role="listbox">
    <div class="item active">
      <%
    int count=0;
    while(count<3 && rs.next()){
        String group_name=rs.getString("group_name");
        count++;
    %>  
    
      <div class="col-sm-4 col-xs-12">
        <div class="panel panel-default text-center">
          <div class="panel-heading">
            <h1><%=group_name%></h1>
          </div>
          <div class="panel-body">
          </div>
          <div class="panel-footer">
            <button class="btn btn-lg">Join</button>
          </div>
        </div>      
      </div>
     
       <%
       }
    %>
    </div>   
    
    <div class="item">
      <%
        int counter=0; 
        while(counter<3 && rs.next()){
        String group_name=rs.getString("group_name");
        counter++;
        %>  
          <div class="col-sm-4 col-xs-12">
            <div class="panel panel-default text-center">
              <div class="panel-heading">
                <h1><%=group_name%></h1>
              </div>
              <div class="panel-body">
              </div>
              <div class="panel-footer">
                <button class="btn btn-lg">Join</button>
              </div>
            </div>      
          </div>
       <%
           
       }
       %>
    </div>
    <%
        }catch(Exception ex){
            System.out.println("Exception while rendering groups in slider on index: "+ex);
       }

       %>
    </div>
    <button class="btn btn-lg panel" style="width: 130px;background: black;color: white;">Find more</button>
  </div>
</div>
</div>
<!-- Left and right controls -->
<div style="width: 10%;float:right;">
<a class="right carousel-control" href="#myCarousel" style="margin-top: 670px;" role="button" data-slide="next">
  <span><i class="right" aria-hidden="true"></i></span>
  <span class="sr-only">Next</span>
</a>
</div>

</section>
      <!-- Section "Statistics" -->
<%
    
    String grpCount=null,userCount=null,eventCount=null,newUsers=null;
    try{
    Statement stGrpCount = con.createStatement();
    Statement stUserCount = con.createStatement();
    Statement stEventCount = con.createStatement();
    Statement stNewUsers = con.createStatement();
    
    ResultSet rs = stGrpCount.executeQuery("Select count(*) as grpCount from group_details");
    ResultSet rs2 = stUserCount.executeQuery("Select count(*) as usrCount from users");
    ResultSet rs3 = stEventCount.executeQuery("Select count(*) as eventCount from event");
    ResultSet rs4 = stNewUsers.executeQuery("Select count(*) as newUsrCount from users where acc_created between date_sub(now(), INTERVAL 1 WEEK) AND now()");
    rs.next();
    rs2.next();
    rs3.next();
    rs4.next();
%>
      
<section id="statistics" class="sig-container sig-row sig-center sig-dark-grey sig-padding-64">
  <div class="slideanim">
    <div class="sig-quarter">
      <span class="sig-xxlarge"><%=rs.getString("grpCount")%></span>
      <br>Active Groups
    </div>
    <div class="sig-quarter">
      <span class="sig-xxlarge"><%=rs2.getString("usrCount")%></span>
      <br>Active Users
    </div>
    <div class="sig-quarter">
      <span class="sig-xxlarge"><%=rs3.getString("eventCount")%></span>
      <br>Events Conducted
    </div>
    <div class="sig-quarter">
      <span class="sig-xxlarge"><%=rs4.getString("newUsrCount")%></span>
      <br>New Users Last Week
    </div>
  </div>
</section>
      
<%
        }catch(Exception exx){
            System.out.println("Exception while getting stat on index: "+exx);
        }
%>
<!-- Container (Contact Section) -->
<section id="contact" class="container-fluid">
  <h2 class="text-center">CONTACT</h2>
  <div class="row"> 
    <div class="col-sm-5">
      <p>Contact us and we'll get back to you within 24 hours.</p>
      <p>Katraj, Pune</p>
      <p>+91 8888888888 </p>
      <p>elkorf.user@gmail.com</p>
    </div>
    <div class="col-sm-7 slideanim">
    <form action="saveFeedback" method="post">    
      <div class="row">
        <div class="col-sm-6 form-group">
          <input class="form-control" id="name" name="name" placeholder="Name" type="text" required>
        </div>
        <div class="col-sm-6 form-group">
          <input class="form-control" id="email" name="email" placeholder="Email" type="email" required>
        </div>
      </div>
        <textarea class="form-control" id="comments" name="comment" placeholder="Comment" rows="5" required></textarea><br>
      <div class="row">
        <div class="col-sm-12 form-group">
            <button class="btn btn-default pull-right" type="submit">Send</button>
        </div>
      </div>
    </form>
    </div>
  </div>
</section>
<section>
  <footer class="container-fluid text-center sig-dark-grey">
    <a href="#myPage" title="To Top">
      <span><i class="up"></i></span>
    </a>
    <div class="small text-center text-white">Copyright &copy; 2019 - SIG</div>
    <br>
  </footer>
</section>

<!----------------------Login Modal--------------------------------->
<div class="modal fade" id="login" name="login" role="dialog" style="overflow:scroll;">
    <div class="modal-dialog"> 
        <!-- Modal content-->
        <div class="modal-content" style="margin-top:80px;">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4>Login</h4>
            </div>
            
            <div class="modal-body">
                <form role="form" action="login" method="post">
                    <div class="form-group">
                        <label for="usrname"></span> Username</label>
                        <input type="text" class="form-control" id="usrname" name="userid" placeholder="Username" required autocomplete="off">
                    </div>
                    <div class="form-group">
                        <label for="psw">Password</label>
                        <input type="password" class="form-control" name="password" id="psw" placeholder="Password" required>
                    </div>
                    <div class="checkbox">
                        <label><input type="checkbox" value="" checked>Remember me</label>
                    </div>
                    <div>
                        <div type="cancle" class="btn btn-danger btn-default btn-lg" style="width:50%;float: left;" data-dismiss="modal">Cancel</div>
                        <button type="submit" class="btn btn-success btn-lg" style="width:50%; float: right;">Login</button>
                    </div>
                </form>
            </div>
            <br>
            <div class="modal-footer">
                <div style="float:left;"><p>Forgot <a href="forgotPassword.jsp">Password?</a></p></div>
                <div style=float:right;"><p>Not a member? <a class="btn btn-light" data-toggle="modal" data-target="#signup" data-dismiss="modal">Sign Up</a></p></div>
            </div>
        </div>
    </div>
</div>
<!----------------------Signup Modal--------------------------------->
<div class="modal fade" id="signup" name="signup" role="dialog" style="overflow:scroll;">
    <div class="modal-dialog"> 
        <!-- Modal content-->
        <div class="modal-content" style="margin-top:80px;">
            <div class="modal-header" >
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4>Sign Up</h4>
            </div>
            <div class="modal-body">                   <!--MESSGE HANDLER-->
                <form role="form" action="register" method="post">
                    <div class="form-group">
                        <label for="username">Username</label>
                        <input type="text" class="form-control" autocomplete="off" name="userid" id="userid" placeholder="Username" onkeyup="chkUnme(this.value);" required>
                        <div id="msg"></div>
                    </div>
                    <div class="form-group">
                        <label for="name">Name</label>
                        <input type="text" class="form-control" id="name" name="name" placeholder="Name" required>
                    </div>
                    <div class="form-group">
                        <label for="phone">Mobile No.</label>
                        <input type="tel" class="form-control" id="phone" maxlength="10" pattern="[6-9]{1}[0-9]{9}" name="mobile" placeholder="MObile No." required>
                    </div>
                    <div class="form-group">
                        <label for="usrname">Email</label>
                        <input type="email" class="form-control" id="email" name="email" placeholder="Email" required>
                    </div>
                    <div class="form-group">
                        <label for="psw">Password</label>
                        <input type="password" class="form-control" name="password" id="psw1" placeholder="Password" required>
                    </div>
                    <div class="form-group">
                        <label for="psw-cnf">Confirm Password</label>
                        <input type="password" class="form-control" name="repassword" id="psw2" placeholder="Confirm" required>
                    </div>
<!--                    <div class="checkbox">
                        <label><input type="checkbox" value="" checked>I Agree <a>Terms & Conditions</a></label>
                    </div>-->
                    <div>
                        <div type="close" class="btn btn-danger btn-default btn-lg" style="width:50%;float: left;" data-dismiss="modal">Cancel</div>
                        <button type="submit" class="btn btn-success btn-lg" style="width:50%; float: right;">Register</button>
                    </div>
                </form>
            </div>
            <br>
            <div class="modal-footer">
                <!--<div style="float:left;"><p>Forgot <a href="forgotPassword">Password?</a></p></div>-->
                <div style=float:right;"><p>Already a member? <a class="btn btn-light" data-toggle="modal" data-target="#login" data-dismiss="modal">Log In</a></p></div>
            </div>
        </div>
    </div>
</div>
<script>
            var xmlHttp;

            function chkUnme(inputString) {
                if (inputString.length == 0) {
                    document.getElementById("msg").innerHTML = "";
                    return;
                }
                try {
                    if (window.XMLHttpRequest)
                        xmlHttp = new XMLHttpRequest();
                    else if (window.ActiveXObject)
                        xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
                    if (!xmlHttp || xmlHttp == null) {
                        return;
                    }
                    var url = "LiveValidateUsername?userName=" + inputString; // Here, I have mapped servlet as "validate".
                    xmlHttp.onreadystatechange = StateChanged;
                    xmlHttp.open("GET", url, true);
                    xmlHttp.send(null);
                } catch (e) {
                    document.getElementById("msg").innerHTML = "An error occured";
                }
            }
            
            function StateChanged() {
                if ((xmlHttp.readyState == 4) && (xmlHttp.status == 200)) {
                    var res = String(xmlHttp.responseText);
                    var vres = "Username is available";
                    var n = res.localeCompare(vres);
                    
                    if(n == -1)
                    {
                        document.getElementById("msg").innerHTML = res;
                        document.getElementById("userid").style.border = "1px solid red";
                        document.getElementById("msg").style.color = "red";
                    }else{

                        document.getElementById("msg").innerHTML = res;
                        document.getElementById("msg").style.color = "green";
                        document.getElementById("userid").style.border = "1px solid green";
                    }
                    
//                    document.getElementById("userid").style.border = "1px solid red";
                }
            }
    </script>
</body>
</html>

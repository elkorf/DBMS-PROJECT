<%-- 
    Document   : forgotPassword
    Created on : 14 Oct, 2019, 11:27:20 PM
    Author     : elkorf
--%>
<html>
<head>
<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<meta name="viewport" content="width=device-width,initial-scale=1">
	<meta name="description" content="">
	<meta name="author" content="">

  	<!--Bootstrap-->
  	<link rel="stylesheet" href="lib/bootstrap/css/bootstrap.min.css">

	<!--Css-->
	<link rel="stylesheet" href="css/dashboard.css">

</head>
<body id="page-top" style="background: #f4eef5">

<!--Navigation bar-->
	<nav class="navbar navbar-expand navbar-dark bg-dark fixed-top">                                                       
	    <a class="navbar-brand mr-1" href="home.jsp">#SIGMS</a>
	</nav>

<div style="margin-top: 200px;">
<center>
    <%@include file="messages.jsp"%>
<form action="ForgotPassHandler.jsp" method="post">        
    <div class="col-sm-4">
        <div class="card shadow bg-light rounded">
            <div class="card-body text-center text-bold">
                <div>
                    <h2>Enter Your Email Associated with account here:</h2>
                    <input type="email" id="forgot" placeholder="Email" name="email" required>
                </div>
                <br>
                <div>
                    <button class="btn btn-info btn-lg">Cancel</button>
                    <button type="submit" class="btn btn-danger btn-lg">Send</button>
                </div>    
            </div>
        </div>
    </div>
</form>   
</center>    
<!-- end o  f content section-->
</div>
<script src="lib/js/sidebar_size.js"></script>                                            
<script src="lib/jquery/jquery.min.js"></script>
<script src="lib/bootstrap/js/bootstrap.min.js"></script>
</body>
</html>     
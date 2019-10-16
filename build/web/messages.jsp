<%  
    try{
        String show_message = (String) session.getAttribute("alert_message");
        if (show_message != null) 
        {
            String flash_type = (String) session.getAttribute("alert_type");
            if (flash_type == null) 
            {
                flash_type = "success";
            }
    %>
            <div class="container">
                <div class="alert alert-<%=flash_type%> alert-dismissible fade show" role="alert">
                    <strong>
                        <%=show_message%>
                    </strong>
                    <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                    
                </div>
            </div>
    <%
        session.setAttribute("alert_message",null);
        session.setAttribute("alert_type",null);
     
    %>
    <script src="lib/jquery/jquery.min.js"></script>
    <script src="lib/bootstrap/js//bootstrap.min.js"></script>
    <%
        }
    }
    catch(Exception exxx){
        System.out.println("Exception occured in message display file: "+exxx.toString());
    }
    %>
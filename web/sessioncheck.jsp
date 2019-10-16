<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
   
   String scheck = null;
   
   try{
       scheck=(String) session.getAttribute("uid");
        if(scheck==null)
        {    
            //System.out.println("not logged in");
            response.sendRedirect("index.jsp");
            return;
        }
   }catch(Exception ex)
   {
       System.out.println("EX in sessionchk : "+ex.toString());
   }
   
%>

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package user;

import db.Dbconn;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author manas
 */
public class JoinGroup extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
       
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
        HttpSession session = request.getSession(true);
        
        try{
            String grp = request.getParameter("sigid");
            String uid = session.getAttribute("uid").toString();
            
            if(grp != null && uid != null){
                
                //connecting database
                Dbconn db = new Dbconn();
                Connection con = db.connect();
                
                //first check if user is already a member of that group
                Statement st2 = con.createStatement();
                ResultSet rs = st2.executeQuery("select * from group_members where group_id='"+grp+"' and user_id='"+uid+"' ");
                
                if(rs.next())   //if user is already a member of that group
                {
                    session.setAttribute("alert_message","You are already a member of this group!");
                    session.setAttribute("alert_type","warning");
                    response.sendRedirect("groupContentPosts.jsp?sigid="+grp);
                }
                else{
                
                    String sql = "insert into group_members(group_id , user_id) values ('"+grp+"' , '"+uid+"') ";
                    Statement st = con.createStatement();
                    int flag = st.executeUpdate(sql);

                    if(flag > 0)
                    {
                        //grp joined
                        session.setAttribute("alert_message","You are now a member of this group!");
                        session.setAttribute("alert_type","success");
                        response.sendRedirect("groupContentPosts.jsp?sigid="+grp);
                    }else{
                        //grp joining failed
                        session.setAttribute("alert_message","Some unavoidable error occured while joining the group!");
                        session.setAttribute("alert_type","danger");
                        response.sendRedirect("newSig.jsp");
                    }
                }
            }else{ 
                //varibales are null (no data recieved)
                session.setAttribute("alert_message","Some unavoidable error occured while joining the group: Improper data reception!");
                session.setAttribute("alert_type","danger");
                response.sendRedirect("home.jsp");
            }
        }catch(Exception e){
            System.out.println("Exception occred while adding user to a group: "+e);
            session.setAttribute("alert_message","Some unavoidable error occured while joining the group: Runtime Exception!");
            session.setAttribute("alert_type","danger");
            response.sendRedirect("home.jsp");
        }
    }


    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "THIS SERVLET WILL ADD AN USER TO A GROUP AND REDIRECT HIM TO GROUP PAGE";
    }// </editor-fold>

}

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package user;

import db.Dbconn;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.CallableStatement;
import java.sql.Connection;
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
public class LeaveGroup extends HttpServlet {

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
            
            //connecting databse
            Dbconn db = new Dbconn();
            Connection con = db.connect();
            
            String grp = request.getParameter("sigid");
            String user = request.getParameter("uid");
            
            System.out.println("uid : "+user);
            
            if(grp == null || user == null){
                session.setAttribute("alert_message","Something went wrong try again later possible incomplete values!");
                session.setAttribute("alert_type","warning");
                response.sendRedirect("groupDashboard.jsp?sigid="+grp);
            }else{
                
                //create callable statement object for calling procedure
//                String query = "{ call leave_group(?,?) }";
//                CallableStatement cst = con.prepareCall(query);  //for answers
//                
//                cst.setString(1, grp);
//                cst.setString(2, user);
//                
//                Boolean res = cst.execute();
//              
                con.setAutoCommit(false);
                
                Statement st1,st2,st3,st4,st5,st6;
                
                st1 = st2 = st3 = st4 = st5 = st6 = con.createStatement();
                
//                int r1 = st1.executeUpdate("delete from `event` where user_id = '"+user+"' and group_id = '"+grp+"';");
//                int r2 = st2.executeUpdate("delete from `answers` where user_id = '"+user+"' and question_id in (select question_id from questions where group_id = '"+grp+"');");
//                int r3 = st3.executeUpdate("delete from `comments` where user_id = '"+user+"' and post_id in (select post_id from post where group_id = '"+grp+"');");
//                int r4 = st4.executeUpdate("delete from `post` where user_id = '"+user+"' and group_id = '"+grp+"';");
//                int r5 = st5.executeUpdate("delete from `questions` where user_id = '"+user+"' and group_id = '"+grp+"';");
                    System.out.println("delete from `group_members` where user_id = '"+user+"' and group_id = '"+grp+"';");
                int r6 = st6.executeUpdate("delete from `group_members` where user_id = '"+user+"' and group_id = '"+grp+"';");
                if(r6 > 0){
                    con.commit();
                    session.setAttribute("alert_message","You have been removed from this group!");
                    session.setAttribute("alert_type","success");
                    response.sendRedirect("groupDashboard.jsp?sigid="+grp);
                }else{
                    con.rollback();
                    session.setAttribute("alert_message","Something went wrong try again later!");
                    session.setAttribute("alert_type","warning");
                    response.sendRedirect("groupDashboard.jsp?sigid="+grp);
                }                
            }            
        }catch(Exception ex){
            System.out.println("Exception occured while removing user from a group: "+ex.toString());
        }
        
    }

    @Override
    public String getServletInfo() {
        return "WILL REMOVE A USER FROM GROUP";
    }// </editor-fold>

}

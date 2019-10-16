/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package user;

import db.Dbconn;
import java.io.IOException;
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
public class CreateSig extends HttpServlet {

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

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
        
        try{
            HttpSession session = request.getSession(true);
            //connecting databse
            Dbconn db = new Dbconn();
            Connection con = db.connect();
            
            con.setAutoCommit(false);
            
            String sigid = request.getParameter("grpid");
            String signme = request.getParameter("gname");
            String desc = request.getParameter("description");
            
            Statement st = con.createStatement() , st2 = con.createStatement();
            
            int rs = st.executeUpdate("insert into `group_details` (group_id, group_name, description, created_by) "
                    + "values ('"+sigid+"','"+signme+"','"+desc+"','"+session.getAttribute("uid")+"')");
            
            if(rs > 0){
                int rs2 = st2.executeUpdate("insert into `group_members` values('"+sigid+"', '"+session.getAttribute("uid")+"' ,'admin' )");
                if(rs2 >0){
                    con.commit();
                    session.setAttribute("alert_message","Sig Created Successfully");
                    session.setAttribute("alert_type","success");
                    response.sendRedirect("newSigs.jsp");
                }else{
                    con.rollback();
                    session.setAttribute("alert_message","Sig Creation Faled!");
                    session.setAttribute("alert_type","danger");
                    response.sendRedirect("newSigs.jsp");
                }
            }else{
                con.rollback();
                session.setAttribute("alert_message","Sig Creation Faled!");
                session.setAttribute("alert_type","danger");
                response.sendRedirect("newSigs.jsp");
            }
            
        }catch(Exception ex){
            System.out.println("Exception occured while creating sig: "+ex);
        }
        
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Add a new sig";
    }// </editor-fold>

}

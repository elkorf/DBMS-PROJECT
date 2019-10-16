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

/**
 *
 * @author manas
 */
public class LiveValidateGid extends HttpServlet {

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
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
        PrintWriter out = response.getWriter();
        String strStatus = "Group Id is available";
        
        try{
            //System.out.println("Performing check");
            String gid = request.getParameter("gid");
            
            //CONNECTING DATABASE
            Dbconn db=new Dbconn();
            Connection con =db.connect();
            
            String query = "SELECT * FROM group_details WHERE group_id='" + gid +"'";
            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery(query);
            
            boolean idExists = rs.next();
            
            if (idExists){
                strStatus = "Group Id Already Taken"; // Return Exist Msg
            }
        }catch(Exception e){
            strStatus = "Some error occured. Try again"; // Return Err Msg
            e.printStackTrace();
        }
        out.println(strStatus);
    }

    @Override
    public String getServletInfo() {
        return "Live validate groupid";
    }// </editor-fold>

}

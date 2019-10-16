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
public class AddAnswer extends HttpServlet {

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
            
            String ansData = request.getParameter("answer-data");
            String qid = request.getParameter("question_id");
            
            //CONNECTING DATABASE
            Dbconn db=new Dbconn();
            Connection con =db.connect();
            
            Statement st = con.createStatement();
            String grp = session.getAttribute("sigid").toString();
            
            String sql = "insert into `answers` (answer,question_id,user_id) values ('"+ansData+"', '"+qid+"' , '"+session.getAttribute("uid").toString()+"' ) ";
            System.out.println(sql);
            
            int rs = st.executeUpdate(sql);
            
            if(rs > 0){
                session.setAttribute("alert_message","Answer Posted!");
                session.setAttribute("alert_type","success");
                response.sendRedirect("groupContentQuestions.jsp?sigid="+grp);
            }else{
                session.setAttribute("alert_message","Something went Wrong!");
                session.setAttribute("alert_type","warning");
                response.sendRedirect("groupContentQuestions.jsp?sigid="+grp);
            }
            
        }catch(Exception ex){
            System.out.println("Exception occured while adding new Answer! "+ex);
        }
        
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Add a new answer to question";
    }// </editor-fold>

}

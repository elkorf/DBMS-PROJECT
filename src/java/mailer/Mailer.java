/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package mailer;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Properties;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author manas
 */
public class Mailer extends HttpServlet {

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
        HttpSession session = request.getSession(true);
        
        String mail =  (request.getParameter("mail") != null) ? request.getParameter("mail").trim() : "null";
        String msg = request.getParameter("msg").trim();
        String page = request.getParameter("page").trim();
        if(mail.equals("null"))
            mail = session.getAttribute("email").toString().trim();
        
        if(!msg.isEmpty()){
        
            String result;
            //Recipient's email ID needs to be mentioned.
            String to = mail;

            // Sender's email ID needs to be mentioned  username should also be your email
            String from = "system.sigms@gmail.com";
            final String username = "system.sigms@gmail.com";
            final String password = "<password gos here>";

            //host here we are using gsmtp
            String host = "smtp.gmail.com";         //while using gsmtp your sender should be a gmail account

            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.host", host);
            props.put("mail.smtp.port", "587");

            //Get the Session object.
            Session mailSession = Session.getInstance(props,
                            new javax.mail.Authenticator() {
                                    protected PasswordAuthentication getPasswordAuthentication() {
                                            return new PasswordAuthentication(username,
                                                            password);
                                    }
                            });

            try {
                    // Create a default MimeMessage object.
                    Message message = new MimeMessage(mailSession);

                    // Set From: header field of the header.
                    message.setFrom(new InternetAddress(from));

                    // Set To: header field of the header.
                    message.setRecipients(Message.RecipientType.TO,
                                    InternetAddress.parse(to));

                    // Set Subject: header field
                    message.setSubject("System Update");

                    // Now set the actual message
                    message.setText(msg);

                    // Send message
                    Transport.send(message);

                    //System.out.println("Sent message successfully....");
                    session.setAttribute("alert_message","You have been notified!");
                    session.setAttribute("alert_type","success");
                    response.sendRedirect(page);

            } catch (MessagingException e) {
                    System.out.println(e);
                    session.setAttribute("alert_message","Mailer Failed!");
                    session.setAttribute("alert_type","danger");
                    response.sendRedirect(page);
            }
        }
        
    }
    @Override
    public String getServletInfo() {
        return "Sends mail";
    }// </editor-fold>

}

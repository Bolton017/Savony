package rapport.mail;
 
import java.util.Properties;    
import javax.mail.*;    
import javax.mail.internet.*;
 

public class Mail {
    String sender;
    String password;
    String to;
    String[] cc;
    String subject;
    String message;

    public void setSender(String from)throws Exception{
        if(from==null || from.isEmpty()==true)throw new Exception("Sender obligatoire");
        this.sender=from;
    }
    public String getSender(){
        return this.sender;
    }

    public void setPassword(String password)throws Exception{
        if(password==null || password.isEmpty()==true)throw new Exception("Mot de passe obligatoire");
        this.password=password;
    }
    public String getPassword(){
        return this.password;
    }

    public void setTo(String to)throws Exception{
        if(to==null || to.isEmpty()==true)throw new Exception("Destinataire obligatoire");
        this.to=to;
    }
    public String getTo(){
        return this.to;
    }

    public void setCc(String[] cc)throws Exception{
        this.cc=cc;
    }
    public String[] getCc(){
        return this.cc;
    }

    public void setSubject(String subject){
        this.subject=subject;
    }
    public String getSubject(){
        return this.subject;
    }
    
    public void setMessage(String message){
        this.message=message;
    }
    public String getMessage(){
        return this.message;
    }

    public Mail(){
    }

    public Mail(String sender,String password,String subject,String message)throws Exception{
        this.setSender(sender);
        this.setPassword(password);
        this.setSubject(subject);
        this.setMessage(message);
    }

    public void send()throws Exception{
        Properties props = new Properties();    
        props.put("mail.smtp.host", "smtp.googlemail.com");    
        props.put("mail.smtp.socketFactory.port", "465");    
        props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");    
        props.put("mail.smtp.auth", "true");    
        props.put("mail.smtp.port", "465"); 
        props.put("mail.smtp.ssl.enable", "true");
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");
        
        String from=this.getSender();
        String mdp=this.getPassword();

        Session session = Session.getInstance(props,    
         new javax.mail.Authenticator() {    
            protected PasswordAuthentication getPasswordAuthentication() { 
                // System.out.println(from);
                // System.out.println(mdp);   
            return new PasswordAuthentication(from,mdp);  
         }    
        });    

        try {    
            MimeMessage message = new MimeMessage(session);    
            message.addRecipient(Message.RecipientType.TO,new InternetAddress(this.getTo()));
            if(this.getCc()!=null){
                InternetAddress[] tabCC=new InternetAddress[this.getCc().length];
                for(int i=0; i<tabCC.length; i++)
                {
                    tabCC[i]=new InternetAddress(this.getCc()[i]);
                }
                 message.addRecipients(Message.RecipientType.CC,tabCC);
            }

            message.setSubject(this.getSubject());    
            message.setContent(this.getMessage(),"text/html"); 

            Transport.send(message);    
            // System.out.println("Email envoy? avec succ?s!");    
        } catch (MessagingException e) {throw new RuntimeException(e);}

        
    }
}

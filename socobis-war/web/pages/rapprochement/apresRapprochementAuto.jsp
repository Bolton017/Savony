<%@page import="user.UserEJB"%>
<%@page import="utilitaire.UtilDB"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.SQLException"%>
<%@ page import="rapprochement.RapprochementBC" %>
<%@ page import="rapprochement.RapprochementDBMere" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    Connection connection = null;
    try{
        UserEJB u = (UserEJB)session.getAttribute("u");
        connection = new UtilDB().GetConn();
        String lien = (String)session.getAttribute("lien");
        String bute = request.getParameter("bute");
        String[] ids = request.getParameterValues("ids");

        for (String idFor : ids) {
            System.out.println("ids = " + idFor);
            String idEcriture = idFor.split("_")[0];
            String idReleve = idFor.split("_")[1];

            System.out.println("id Ecriture = " + idEcriture);
            System.out.println("id Releve = " + idReleve);
            RapprochementDBMere mere = new RapprochementDBMere();
            mere.rapprochement(u.getUser().getTuppleID(), new String [] {idEcriture}, new String [] {idReleve},connection);
            //RapprochementBC rb = new RapprochementBC();
            //rb.rapprochement(u.getUser().getTuppleID(), new String [] {idEcriture}, new String [] {idReleve},connection);
            bute = "rapprochement/liste-rapprochement.jsp";
        }

%>
<script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute%>");</script>
<%
}catch (Exception e) {
    e.printStackTrace();
%>

<script language="JavaScript"> alert("<%=new String(e.getMessage().getBytes(), "UTF-8")%>");
history.back();</script>
<%
        return;
    } finally {
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
%>
<%@page import="utilitaire.UtilDB"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.SQLException"%>
<%@ page import="faturefournisseur.DmdAchat" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    Connection connection = null;
    try{
        connection = new UtilDB().GetConn();
        String lien = (String)session.getAttribute("lien");
        String id = request.getParameter("iddmdachat");
        String bute = "facturefournisseur/dmdachat/dmdachat-fiche.jsp&id=" + id;

        DmdAchat demande = (DmdAchat) new DmdAchat().getById(id, null, connection);
        demande.genererBcMultiple(connection);

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
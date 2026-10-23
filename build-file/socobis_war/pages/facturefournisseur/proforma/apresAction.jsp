
<%@page import="user.UserEJB"%>
<%@page import="utilitaire.UtilDB"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.SQLException"%>
<%@ page import="faturefournisseur.proforma.ProformaFournisseurDetails" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    Connection connection = null;
    try{
        UserEJB u = (UserEJB)session.getAttribute("u");
        connection = new UtilDB().GetConn();
        String lien = (String)session.getAttribute("lien");
        String bute = request.getParameter("bute");
        String idDmd = request.getParameter("iddmd");
        String realBute = "facturefournisseur/dmdachat/dmdachat-fiche.jsp&id=" + idDmd + "&tab=inc/proforma-liste";

        String id = request.getParameter("id");
        String toEtat = request.getParameter("to");
        int etat = Integer.parseInt(toEtat);
        new ProformaFournisseurDetails().updateEtat(etat, id, connection);

%>
<script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=realBute%>");</script>
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

<%@page import="user.UserEJB"%>
<%@page import="utilitaire.UtilDB"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.SQLException"%>
<%@ page import="faturefournisseur.proforma.ProformaFournisseurDetails" %>
<%@ page import="faturefournisseur.proforma.ProformaFournisseur" %>
<%@ page import="faturefournisseur.As_BonDeCommande" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    Connection connection = null;
    try{
        UserEJB u = (UserEJB)session.getAttribute("u");
        connection = new UtilDB().GetConn();
        String lien = (String)session.getAttribute("lien");
        String id = request.getParameter("id");
        String idDmd = request.getParameter("iddmd");
        String realBute = "facturefournisseur/dmdachat/dmdachat-fiche.jsp&id=" + idDmd + "&tab=inc/proforma-liste-valide";
        if (request.getParameter("p") != null) {
            realBute = "facturefournisseur/proforma/proforma-fiche.jsp&id=" + id;
        }

        ProformaFournisseur pro = (ProformaFournisseur) new ProformaFournisseur().getById(id, null, connection);
        As_BonDeCommande bc = pro.genererBc(connection);
        if (bc != null) {
            bc.createObject(String.valueOf(u.getUser().getRefuser()), connection);
            bc.validerObject(String.valueOf(u.getUser().getRefuser()), connection);
        } else {
            throw new Exception("Impossible de generer le bon de commande");
        }
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
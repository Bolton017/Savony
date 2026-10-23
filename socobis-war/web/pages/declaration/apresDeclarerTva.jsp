<%@page import="paiement.*" %>
<%@page import="user.UserEJB" %>
<%@page import="utilitaire.*" %>
<%@ page import="declaration.DeclarationTva" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<% try {
    UserEJB u = (UserEJB) session.getAttribute("u");
    String lien = (String) session.getAttribute("lien");
    String bute = request.getParameter("bute");
    String designation = request.getParameter("designation");
    String datydebut = request.getParameter("datydebut");
    String datyfin = request.getParameter("datyfin");
    String totalcollecter = request.getParameter("totalcollecter");
    String[] ids = request.getParameterValues("ids");
    String idsOrigin = request.getParameter("idsOrigin");
    String estOrigin = request.getParameter("estOrigin");
    String redirection = lien+"?but="+bute;

    if (estOrigin != null && estOrigin.equalsIgnoreCase("true")) {
        String paramSup = "&datydebut="+datydebut;
        paramSup += "&datyfin="+datyfin;
        paramSup += "&designation="+designation;
        paramSup += "&idsOrigin="+String.join(";", ids);
        paramSup += "&totalcollecter="+totalcollecter;
        redirection += paramSup;
    } else {
        String[] idsOrigins = idsOrigin.split(";");
        DeclarationTva dtva = new DeclarationTva();
        dtva.setDesignation(designation);
        dtva.setDatydebut(Utilitaire.stringDate(datydebut));
        dtva.setDatyfin(Utilitaire.stringDate(datyfin));
        dtva.enregistrerDeclaration(idsOrigins, ids, u.getUser().getTuppleID(), null);
        String id = dtva.getId();
        redirection += "&id="+id;
    }
%>
<script language="JavaScript"> document.location.replace("<%=redirection%>");</script>
<%  } catch (Exception e) {
    e.printStackTrace(); %>
    <script language="JavaScript">
        alert('<%=e.getMessage()%>');
        history.back();
    </script>
<% } %>


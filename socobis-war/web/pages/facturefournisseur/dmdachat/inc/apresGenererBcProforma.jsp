<%--
  Created by IntelliJ IDEA.
  User: Tsinjoniaina
  Date: 04/06/2026
  Time: 16:44
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="user.UserEJB" %>
<%@ page import="faturefournisseur.proforma.ProformaFournisseurDetails" %>
<%@ page import="bean.CGenUtil" %>
<%@ page import="faturefournisseur.DmdAchat" %>
<%
    try{
        UserEJB u = (UserEJB)session.getAttribute("u");
        String lien = (String)session.getAttribute("lien");
        String bute = "facturefournisseur/dmdachat/dmdachat-fiche.jsp&tab=inc/bondecommande-liste";
        String idDmdAchat = request.getParameter("iddmdachat");

        DmdAchat dmdAchat = new DmdAchat();
        dmdAchat.setId(idDmdAchat);
        dmdAchat.genererBcProformaSelectionne(u.getUser().getTuppleID(), null);
%>
<script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute%>&id=<%=idDmdAchat%>");</script>
<%
}catch (Exception e) {
    e.printStackTrace();
%>

<script language="JavaScript">
    alert("<%=new String(e.getMessage().getBytes(), "UTF-8")%>");
    history.back();
</script>
<%
    }
%>

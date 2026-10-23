<%--
  Created by IntelliJ IDEA.
  User: Tsinjoniaina
  Date: 03/06/2026
  Time: 11:59
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="user.UserEJB" %>
<%@ page import="faturefournisseur.proforma.ProformaFournisseurDetails" %>
<%@ page import="bean.CGenUtil" %>
<%
    try{
        UserEJB u = (UserEJB)session.getAttribute("u");
        String lien = (String)session.getAttribute("lien");
        String bute = "facturefournisseur/dmdachat/dmdachat-fiche.jsp&tab=inc/comparaison-prix";
        String idProformaFille = request.getParameter("idPF");
        String idDmdAchat = request.getParameter("iddmdachat");

        ProformaFournisseurDetails p = new ProformaFournisseurDetails();
        p.setNomTable("PROFORMAFOURNISSEURDETAILS");
        p.setId(idProformaFille);
        ProformaFournisseurDetails[] ps = (ProformaFournisseurDetails[]) CGenUtil.rechercher(p, null, null, null, "");
        if(ps.length==0){
            throw new Exception("Proforma Fille Introuvable");
        }
        ps[0].setNomTable("PROFORMAFOURNISSEURDETAILS");
        ps[0].choisirPropotion(u.getUser().getTuppleID(), ps[0].getEtat(),idDmdAchat);
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
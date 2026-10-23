

<%@page import="utils.ConstanteEtatStation"%>
<%@page import="bean.CGenUtil"%>
<%@page import="vente.Vente"%>
<%@page import="user.UserEJB"%>
<%@page import="user.UserEJBBean"%>
<%@page import="utilitaire.UtilDB"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.SQLException"%>
<%@page import="vente.As_BondeLivraisonClient"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
try{
        UserEJB u = (UserEJB)session.getAttribute("u");
        String lien = (String)session.getAttribute("lien");
        String acte = request.getParameter("acte");
        String bute = "bondelivraison-client/bondelivraison-client-fiche.jsp";
        String type = request.getParameter("type");
        String nomtable=request.getParameter("nomtable");
        String id=request.getParameter("id");

        if (acte.compareToIgnoreCase("valider_preparation") == 0) {
            System.out.println("acte*****************");
            As_BondeLivraisonClient blc=new As_BondeLivraisonClient();
            blc.setId(id);
            blc.validerPreparation(u.getUser().getTuppleID(),null);

                
        }
%>
        <script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute%>&id=<%=id%>");</script>
<%  
}catch (Exception e) {
        e.printStackTrace();
%>

    <script language="JavaScript"> alert("<%=new String(e.getMessage().getBytes(), "UTF-8")%>");
history.back();</script>
<%
        return;
}
%>
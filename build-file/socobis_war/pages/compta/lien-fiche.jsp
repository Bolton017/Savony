
<%@page import="user.UserEJB"%>
<%@page import="utilitaire.UtilDB"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.SQLException"%>
<%@ page import="mg.cnaps.compta.ComptaEcriture" %>
<%@ page import="mg.cnaps.compta.*" %>
<%@ page import="pertegain.*" %>
<%
try{
    String lien = (String)session.getAttribute("lien");
    UserEJB u = (UserEJB)session.getAttribute("u");
    String bute = "";
    String id="";
    if(request.getParameter("type").equals("compte")){

        ComptaCompte compte = new ComptaCompte();
        compte = compte.getIdCompte(request.getParameter("compte"),null);
        id = compte.getId();
        bute = "compta/compte/compte-fiche.jsp&id=" +id;

    }else if(request.getParameter("type").equals("compte_aux")){
        Tiers tiers = new Tiers();
        id = tiers.getTieres(request.getParameter("compteauxiliaire"), null).getId();
        if(id.startsWith("CLI")){
            bute = "client/client-fiche.jsp&id=" +id;
        }else if (id.startsWith("FRN")){
            bute = "fournisseur/fournisseur-fiche.jsp&id=" +id;
        }

    }

%>
<script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute%>");</script>
<%


}catch (Exception e) {
    e.printStackTrace();
}
%>
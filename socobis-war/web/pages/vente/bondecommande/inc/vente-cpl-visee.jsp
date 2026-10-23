<%-- 
    Document   : vente-details
    Created on : 22 mars 2024, 17:05:45
    Author     : Angela
--%>


<%@page import="vente.VenteDetailsLib"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="vente.VenteCplVisee" %>
<%@ page import="vente.VenteLib" %>


<%
    try{
        VenteLib t = new VenteLib();
        String listeCrt[] = {};
        String listeInt[] = {};
        String[] libEntete = {"id","designation","idClientLib","referencefacture","montantttc","montantpaye", "montantreste","etatlib"};
//    id | desce | montantPayé | montantTTC | montantTVA
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        if(request.getParameter("id") != null){
            pr.setAWhere(" and idorigine='"+request.getParameter("id")+"'");
        }
        if (request.getParameter("ido") != null && request.getParameter("ido").isEmpty() == false) {
            pr.setAWhere(" and IDORIGINE='" + request.getParameter("ido") + "'");
        }
        if(request.getParameter("idv") != null && request.getParameter("idv").isEmpty() == false){
            pr.setAWhere(" and id ='"+request.getParameter("idv")+"'");
        }
        String[] colSomme = null;


        pr.creerObjetPage(libEntete, colSomme);
        int nombreLigne = pr.getTableau().getData().length;
        pr.setLien((String) session.getValue("lien"));
        String[] lienTableau = {pr.getLien() + "?but=vente/vente-fiche.jsp"};
        String[] colonneLien = {"id"};
        pr.getTableau().setLienFille("vente/inc/vente-details.jsp&id=");
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
%>

<div class="box-body">
    <%
        String[] libEnteteAffiche = {"Ref.", "D&eacute;signation","Client","R&eacute;f&eacute;rence facture","Montant TTC","Montant Pay&eacute;","Montant restant","&Eacute;tat"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        VenteLib[] liste=(VenteLib[]) pr.getTableau().getData();
        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
    %>
    <% if(pr.getListe().length > 0) {%>
    <div class="w-100" style="display: flex; flex-direction: row-reverse;">
        <table style="width: 20%"class="table">
            <%--            <tr>--%>
            <%--                <td><b>Montant HT:</b></td>--%>
            <%--                <td><b><%=utilitaire.Utilitaire.formaterAr(AdminGen.calculSommeDouble(pr.getListe(),"montantHT")) %> <%= ((VenteCplVisee)pr.getListe()[0]).getIddevise() %></b></td>--%>
            <%--            </tr>--%>
            <tr>
                <td><b>Montant TVA:</b></td>
                <td><b><%= utilitaire.Utilitaire.formaterAr(AdminGen.calculSommeDouble(pr.getListe(),"montantTva")) %> Ar</b></td>
            </tr>
            <tr>
                <td><b>Montant TTC:</b></td>
                <td><b><%= utilitaire.Utilitaire.formaterAr(AdminGen.calculSommeDouble(pr.getListe(),"montantTTC")) %> Ar</b></td>
            </tr>
        </table>
    </div>
    <%}%>
    <%  }if(pr.getTableau().getHtml() == null)
    {
    %><center><h4>Aucune donne trouvee</h4></center><%
    }


%>
</div>
<%
    } catch (Exception e) {
        e.printStackTrace();
    }%>


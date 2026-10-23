
<%@ page import="stock.*" %>
<%@ page import="affichage.*" %>
<%@ page import="faturefournisseur.As_BonDeCommandeCpl" %>
<%@ page import="faturefournisseur.FactureFournisseurCpl" %>
<%@ page import="maintenance.travaux.MoTravauxLib" %>
<%@ page import="utils.CalendarUtil" %>
<%@ page import="bean.AdminGen" %>
<%@ page import="maintenance.travaux.RapprochementTravaux" %>


<%
    try{
        RapprochementTravaux t = new RapprochementTravaux();
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"idPersonnelLib","dureeEstimatif_hms","dureeReel_hms","ecart_hms","montantEstimatif","montantReel","montantEcart"};
        String libEnteteAffiche[] = {"Personnel","Dur&eacute;e estimative","Dur&eacute;e r&eacute;elle","Dur&eacute;e d'&eacute;cart","Montant estimatif","Montant r&eacute;el","Montant d'&eacute;cart"};
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        if(request.getParameter("id") != null){
            String idFab = request.getParameter("id");
            pr.setAWhere(" and idTravaux='"+idFab+"'");
            pr.setApres("maintenance/travaux/Travaux-fiche.jsp&id="+idFab+"&tab=inc/rapprochement-travaux");
        }
        String[] colSomme = null;
        //pr.setNpp(10);
        pr.creerObjetPage(libEntete, colSomme);
        pr.getTableau().transformerDataString();
//        pr.getTableauRecap().setLibeEntete(new String[]{"","Nombre","Somme des dur&eacute;es estimatives","Montant total"});
//        String lienTableau[] = {pr.getLien() + "?but=facturefournisseur/facturefournisseur-fiche.jsp"};
//        String colonneLien[] = {"id"};
//        pr.getTableau().setLien(lienTableau);
//        pr.getTableau().setColonneLien(colonneLien);
%>

<div class="box-body">
    <%
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
    %>
    <div class="w-100" style="display: flex; flex-direction: row-reverse;">
        <table style="width: 20%"class="table">
            <tr>
                <td><b>Montant estimatif total:</b></td>
                <td><b><%= utilitaire.Utilitaire.formaterAr(AdminGen.calculSommeDouble(pr.getListe(),"montantEstimatif")) %> Ar</b></td>
            </tr>
            <tr>
                <td><b>Montant r&eacute;el total:</b></td>
                <td><b><%= utilitaire.Utilitaire.formaterAr(AdminGen.calculSommeDouble(pr.getListe(),"montantReel")) %> Ar</b></td>
            </tr>
            <tr>
                <td><b>Montant d'ecart total:</b></td>
                <td><b><%= utilitaire.Utilitaire.formaterAr(AdminGen.calculSommeDouble(pr.getListe(),"montantEcart")) %> Ar</b></td>
            </tr>
        </table>
    </div>
    <%  }if(pr.getTableau().getHtml() == null)
    {
    %><center><h4>Aucune donne trouvee</h4></center><%
    }


%>
</div>
<%=pr.getModalHtml("modalContent")%>
<%
    } catch (Exception e) {
        e.printStackTrace();
    }%>


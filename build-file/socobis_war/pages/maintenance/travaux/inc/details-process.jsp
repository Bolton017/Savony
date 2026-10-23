
<%@ page import="stock.*" %>
<%@ page import="affichage.*" %>
<%@ page import="faturefournisseur.As_BonDeCommandeCpl" %>
<%@ page import="faturefournisseur.FactureFournisseurCpl" %>
<%@ page import="maintenance.travaux.MoTravauxLib" %>
<%@ page import="maintenance.travaux.ProcessMaintenanceLib" %>
<%@ page import="bean.AdminGen" %>
<%@ page import="utils.CalendarUtil" %>


<%
    try{
        ProcessMaintenanceLib t = new ProcessMaintenanceLib();
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"id", "idPersonnelLib","dateDebut","heureDebut","dateFin","heureFin","ecart_hms","ecart_seconde"};
        String libEnteteAffiche[] = {"id","Personnel","Date de d&eacute;but","Heure de d&eacute;but","Date de fin","Heure de d&eacute;but","Dur&eacute;e","Dur&eacute;e en (s)"};
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        if(request.getParameter("id") != null){
            String idFab = request.getParameter("id");
            pr.setAWhere(" and idTravaux='"+idFab+"'");
            pr.setApres("maintenance/travaux/Travaux-fiche.jsp&id="+idFab+"&tab=inc/details-process");
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
                <td><b>Dur&eacute;e Totale :</b></td>
                <td><b><%=CalendarUtil.secondToHMS((long) AdminGen.calculSommeDouble(pr.getListe(),"ecart_seconde"))%></b></td>
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


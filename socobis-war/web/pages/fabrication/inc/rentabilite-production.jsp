<%--
  Created by IntelliJ IDEA.
  User: Tsinjoniaina
  Date: 09/03/2026
  Time: 08:48
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="stock.MvtStockFilleTheorique" %>
<%@ page import="affichage.PageRecherche" %>
<%@ page import="bean.AdminGen" %>
<%@ page import="utils.ConstanteProcess" %>
<%@ page import="utils.ConstanteSavonnerie" %>

<%
    try{
        MvtStockFilleTheorique t = new MvtStockFilleTheorique();
        t.setNomTable("STOCKETDEPENSEOFFABTHEPOIDSTH");
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"idproduit","designation","pu","sortie","qteth","Ecartqte","montantsortie","montth","pourcentage","Ecartmontant","poidsTheorique"};
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        if(request.getParameter("id") != null){
            pr.setAWhere(" and idmere ='"+request.getParameter("id")+"' and categorieingredient='"+ConstanteSavonnerie.CATEGORIE_MATIERE_PREMIERE+"'");
        }
        String[] colSomme = null;
        pr.setNpp(10);
        pr.creerObjetPage(libEntete, colSomme);
        int nombreLigne = pr.getTableau().getData().length;
%>

<div class="box-body">
    <%
        String libEnteteAffiche[] =  {"Ingredient","Designation","PU","Quantite","Quantite Theorique", "Ecart Qte","Montant","Montant Theorique","% pratique", "Ecart montant", "Poids Th&eacute;orique(%)"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        MvtStockFilleTheorique[] listeFille=(MvtStockFilleTheorique[]) pr.getTableau().getData();
        double sortie = AdminGen.calculSommeDouble(listeFille, "sortie");
        double qteth = AdminGen.calculSommeDouble(listeFille, "qteth");
        double montant = AdminGen.calculSommeDouble(listeFille, "montantsortie");
        double montth = AdminGen.calculSommeDouble(listeFille, "montth");
        double ecartqte = AdminGen.calculSommeDouble(listeFille, "Ecartqte");
        double ecartmontant = AdminGen.calculSommeDouble(listeFille, "Ecartmontant");

        String styleQte = sortie > qteth ? "color:red;" : "";
        String styleMontant = montant > montth ? "color:red;" : "";

        String styleEcartQte = ecartqte > 0 ? "color:red;" : "";
        String styleEcartMontant = ecartmontant > 0 ? "color:red;" : "";
        MvtStockFilleTheorique.calculerPourcentage(listeFille);

        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());

    %>
    <div class="w-100" style="display: flex; flex-direction: row-reverse;">
        <table style="width: 50%" class="table">
            <tr>
                <td><b>Total Montant Pratique :</b></td>
                <td><b style="<%= styleMontant %>"><%= utilitaire.Utilitaire.formaterAr(montant) %> Ar</b></td>
            </tr>
            <tr>
                <td><b>Total Montant TH:</b></td>
                <td><b><%= utilitaire.Utilitaire.formaterAr(montth) %> Ar</b></td>
            </tr>
            <tr>
                <td><b>Ecart Montant TH:</b></td>
                <td><b style="<%= styleEcartMontant %>"><%= utilitaire.Utilitaire.formaterAr(ecartmontant) %> Ar</b></td>
            </tr>
        </table>
    </div>
    <%
        }else
        {
    %><center><h4>Aucune donne trouvee</h4></center><%
    }


%>
</div>
<%
    } catch (Exception e) {
        e.printStackTrace();
    }%>

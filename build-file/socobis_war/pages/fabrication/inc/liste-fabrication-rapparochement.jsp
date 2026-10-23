<%@page import="stock.*"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="produits.Ingredients" %>
<%@ page import="java.util.*" %>

<%
    try{
        MvtStockFilleTheorique t = new MvtStockFilleTheorique();
        t.setNomTable("STOCKETDEPENSEOFFILLEFABTHE");
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"idproduit","designation","pu","sortie","qteth","Ecartqte","montantsortie","montth","pourcentage","Ecartmontant"};
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        if(request.getParameter("id") != null){
            pr.setAWhere(" and IDOBJET='"+request.getParameter("id")+"'");
            pr.setApres("fabrication/ordre-fabrication-details-fiche.jsp&id="+request.getParameter("id")+"&tab=inc/liste-fabrication-rapparochement");
        }
        String idCat = request.getParameter("idCat");
        if(idCat != null && !idCat.isEmpty()){
            pr.setAWhere(pr.getAWhere() + " and categorieingredient='" + idCat + "'");
        }

        HashMap<String, Vector> tab = t.getRapprochementParCategorie(request.getParameter("id"), "STOCKETDEPENSEOFFILLEFABTHE", null);
        String[] colSomme = null;
        String lienTableau[] = {pr.getLien() + "?but=produits/as-ingredients-fiche.jsp"};
        String colonneLien[] = {"idproduit"};
        String[] attributLien = {"id"};
        String colonneModal[] = {"idproduit"};

%>

<div class="box-body">
    <%
        String libEnteteAffiche[] =  {"Ingredient","Designation","PU","Quantite","Quantite Theorique", "Ecart Qte","Montant","Montant Theorique","% pratique", "Ecart montant"};
        for (String cle : tab.keySet()) {
            Vector<MvtStockFilleTheorique> data = tab.get(cle);
            MvtStockFilleTheorique[] dataArray = new MvtStockFilleTheorique[data.size()];
            data.copyInto(dataArray);
            pr.creerObjetPage(libEntete,colSomme);
            pr.getTableau().setLien(lienTableau);
            pr.getTableau().setColonneLien(colonneLien);
            pr.getTableau().setAttLien(attributLien);
            pr.getTableau().setModalOnClick(true,colonneModal);
            pr.getTableau().setLibelleAffiche(libEnteteAffiche);
            pr.getTableau().setData((bean.ClassMAPTable[])dataArray);
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
            pr.getTableau().transformerDataString();

            if(pr.getTableau().getHtml() != null){
                out.println("<h2>"+cle+"</h2>");
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
    <%  }if(pr.getTableau().getHtml() == null)
    {
    %><center><h4>Aucune donnee trouvee</h4></center><%
        }}
%>
</div>
<%=pr.getModalHtml("modalContent")%>
<%
    } catch (Exception e) {
        e.printStackTrace();
    }%>


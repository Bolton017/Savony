<%@page import="utilitaire.Utilitaire"%>
<%@page import="mg.spat.MvttIntraCaisse"%>
<%@page import="bean.*"%>
<%@page import="utilitaire.*"%>
<%@page import="affichage.PageRecherche"%>
<%
    try {

        MvttIntraCaisse eng = new MvttIntraCaisse();
        eng.setNomTable("MvtIntraCaisse");

        String listeCrt[] = {"id", "designation","idTraite","daty", "caissedepart", "caissearrivee","modepaiement","montant"};
        String listeInt[] = {"daty","montant"};
        String libEntete[] = {"id", "designation","idTraite","daty", "caissedepart", "caissearrivee","modepaiement","montant","remarque","etat"};
        PageRecherche pr = new PageRecherche(eng, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));

        pr.getFormu().getChamp("daty1").setLibelle("Date min");
        pr.getFormu().getChamp("daty2").setLibelle("Date max");
        pr.getFormu().getChamp("montant1").setLibelle("Montant Min");
        pr.getFormu().getChamp("montant2").setLibelle("Montant Max");
        pr.getFormu().getChamp("caissedepart").setLibelle("Caisse Depart");
        pr.getFormu().getChamp("caissearrivee").setLibelle("Caisse Arrivee");
        pr.getFormu().getChamp("modepaiement").setLibelle("Mode de paiement");
       
        pr.setAWhere(" AND etatversement = 1 AND idTraite is not null AND etat="+ConstanteEtat.getEtatCreer());
        pr.setApres("facture/traite-non-versee-liste.jsp");
        String[] colSomme = null;
        pr.creerObjetPage(libEntete, colSomme);
        
        /*Caisse caisse=new Caisse();
        caisse.setDesce("Banque");
        Caisse[] listeCaisse=(Caisse[])CGenUtil.rechercher(caisse,null,null,"");*/
%>

<div class="content-wrapper">
    <section class="content-header">
        <h1>Liste des traites non versees</h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=facture/traite-non-versee-liste.jsp" method="post" name="engagement" id="engagement">
            <% out.println(pr.getFormu().getHtmlEnsemble());%>

        </form>
        <%  
            out.println(pr.getTableauRecap().getHtml());%>
        <br>
        <form action="<%=pr.getLien()%>?but=apresVerserTraite.jsp" method="post">
        <%-- 
        <div>
            <label for="idcaisse">Caisse:</label>
            <select name="idcaisse">
                <%for(int i=0;i<listeCaisse.length;i++){%>
                <option value="<%=listeCaisse[i].getId()%>"><%=listeCaisse[i].getVal()%></option>
                <%}%>
            </select>
        </div> --%>
        
        <%
            String libEnteteAffiche[] = {"id", "designation","Traite","Date", "Caisse Depart", "Caisse Arrivee","Mode Paiement","Montant","Remarque","Etat"};
            pr.getTableau().setLibelleAffiche(libEnteteAffiche);
            pr.getTableau().setNameBoutton("Enregistrer");
            pr.getTableau().setNameActe("versementTraite");
            out.println(pr.getTableau().getHtmlWithCheckbox());
        %>
        <input type="hidden" name="acte" id="acte" value="versementTraite">
        <input type="hidden" name="bute" id="bute" value="facture/traite-non-versee-liste.jsp">
        </form>
        <% out.println(pr.getBasPage()); %>
    </section>
</div>
<%  } catch (Exception e) {
        e.printStackTrace();
    }
%>
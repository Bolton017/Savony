<%@page import="mg.spat.JournalCaisseLibComplet"%>
<%@page import="mg.spat.JournalCaisseMivadika"%>
<%@page import="utilitaire.ConstanteEtat"%>
<%@page import="utilitaire.Constante"%>
<%@page import="affichage.PageRecherche"%>
<%@page import="affichage.Liste"%>
<%@page import="bean.TypeObjet"%>
<%@page import="java.sql.Date"%>
<%@page import="utilitaire.Utilitaire"%>

<%
    try {
        String typecheque = request.getParameter("idtypecheque");
        JournalCaisseLibComplet journalCaisse = new JournalCaisseLibComplet();
        journalCaisse.setNomTable("RECUTRAITE");

        if (request.getParameter("etatvue") != null) {
            journalCaisse.setNomTable(request.getParameter("etatvue"));
        }

        System.out.println("tablename"+journalCaisse.getNomTable());

        String listeCrt[] = {"id", "folio", "caisse", "libelle", "remarque", "dateEffet", "idtraite", "tierslib","idbanquelib","numPiece"};
        String listeInt[] = {"dateEffet"};
        String libEntete[] = {"id", "folio", "valcaisse", "descetypecheque", "numPiece","codefacture", "numcheque", "libelle", "dateSaisie", "dateEffet", "credit", "idtraite", "tierslib","codetiers","idbanquelib"};
        PageRecherche pr = new PageRecherche(journalCaisse, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        pr.setApres("facture/traite-recu-liste.jsp");

        Date lastDate = Utilitaire.dateDuJourSql();
        lastDate.setDate(31);
        lastDate.setMonth(11);
        String debutDate = "01/01/"+Utilitaire.getAnnee(Utilitaire.dateDuJourSql());
        String dateFin = Utilitaire.stringToDateJ("dd/MM/yyyy", lastDate);

        pr.getFormu().getChamp("dateEffet1").setDefaut(debutDate);
        pr.getFormu().getChamp("dateEffet2").setDefaut(dateFin);
        pr.getFormu().getChamp("dateEffet1").setLibelle("Date effet min");
        pr.getFormu().getChamp("dateEffet2").setLibelle("Date effet max");
        pr.getFormu().getChamp("libelle").setLibelle("Libellé");
        pr.getFormu().getChamp("caisse").setLibelle("Caisse");
        //pr.getFormu().getChamp("valcaisse").setDefaut("RECETTES");
        pr.getFormu().getChamp("tierslib").setLibelle("Tiers");
        pr.getFormu().getChamp("idbanquelib").setLibelle("Banque");
        pr.setOrdre(" order by numpiece desc");
        String[] colSomme = {"credit"};
        pr.creerObjetPage(libEntete, colSomme);

%>

<div class="content-wrapper">
    <section class="content-header">
        <h1>Recu Traite</h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=facture/traite-recu-liste.jsp" method="post" name="incident" id="incident">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
            
        </form>

        <%  String lienTableau[] = {pr.getLien() + "?but=treso/journalcaisse-fiche.jsp",pr.getLien() + "?but=facture/traite-fiche.jsp"};
            String colonneLien[] = {"id","idtraite"};
            pr.getTableau().setLien(lienTableau);
            pr.getTableau().setColonneLien(colonneLien);
            out.println(pr.getTableauRecap().getHtml());%>
        <br/>

        <form action="<%=pr.getLien()%>?but=visa-multiple.jsp" method="post" name="id" id="journal-caisse-liste">
            <input type="hidden" name="bute" value="facture/traite-recu-liste.jsp"/>
            <input type="hidden" name="classe" value="mg.spat.JournalCaisse"/>
            <input type="hidden" name="acte" value="viser"/>
            <%
                String libEnteteAffiche[] = {"Id", "Folio", "Caisse", "Type", "Num Piece","facture(s)", "num cheque", "Libellé", "Date Saisie", "Date Effet", "Entrée", "Traite", "Tiers","Codetiers","Banque"};
                pr.getTableau().setLibelleAffiche(libEnteteAffiche);
                pr.getTableau().setNameActe("viser");
                pr.getTableau().setNameBoutton("Viser");

                out.println(pr.getTableau().getHtmlWithCheckbox());
            %>
            
        </form>
        <% out.println(pr.getBasPage());%>
    </section>
</div>

<% } catch (Exception e) {
        e.printStackTrace();

    }%>
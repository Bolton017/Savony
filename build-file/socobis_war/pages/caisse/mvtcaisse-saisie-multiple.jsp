<%@page import="stock.*"%>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@page import="affichage.Liste"%>
<%@page import="affichage.PageInsertMultiple"%>
<%@page import="bean.*"%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="user.UserEJB"%>
<%@ page import="affichage.Champ" %>
<%@ page import="caisse.*" %>
<%@page import="vente.VenteLib"%>

<%
    try {
        UserEJB u = (UserEJB) session.getValue("u");
        int nombreLigne = 10;

        String titre = "Saisie des mouvements de caisse";
        String classeMere = "caisse.MouvementCaisseMere";
        String classeFille = "caisse.MouvementCaisseFille";
        String butApresPost = "caisse/mvtcaisse-fiche-mf.jsp";
        String colonneMere = "idmvtcaissemere";
        VenteLib[] ventes = null;

        String origine = " ";
        if (request.getParameter("origine") != null) {
            origine = request.getParameter("origine");
            VenteLib v = new VenteLib();
            v.setId(origine);
            ventes = (VenteLib[]) CGenUtil.rechercher(v, null, null, null, "");
        }

        MouvementCaisseMere mere = new MouvementCaisseMere();
        MouvementCaisseFille fille = new MouvementCaisseFille();
        PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, nombreLigne, u);
        pi.setLien((String) session.getValue("lien"));

        Liste[] liste = new Liste[2];
        TypeObjet modepaiement = new TypeObjet();
        modepaiement.setNomTable("modepaiement");
        liste[0] = new Liste("idModePaiement", modepaiement, "val", "id");

        Caisse caisse = new Caisse();
        liste[1] = new Liste("idCaisse", caisse, "val", "id");
        pi.getFormufle().changerEnChamp(liste);

//        pi.getFormu().getChamp("designation").setVisible(false);
        pi.getFormu().getChamp("idmodepaiement").setVisible(false);
        pi.getFormu().getChamp("credit").setLibelle("Montant");
        pi.getFormu().getChamp("debit").setVisible(false);
        if(ventes!=null){
            pi.getFormu().getChamp("idtiers").setDefaut(ventes[0].getIdClient());
            //pi.getFormu().getChamp("credit").setDefaut(String.valueOf(ventes[0].getMontantreste()));
            String montant = Utilitaire.formaterAr(ventes[0].getMontantreste());

            pi.getFormu().getChamp("credit").setDefaut(montant);
        }
        pi.getFormu().getChamp("idtiers").setLibelle("Client");
        pi.getFormu().getChamp("idtiers").setPageAppelComplete("client.Client", "id", "Client");


        pi.getFormu().getChamp("idorigine").setLibelle("Origine");
        pi.getFormu().getChamp("idorigine").setAutre("readonly");
        pi.getFormu().getChamp("idorigine").setDefaut(origine);
        pi.getFormu().getChamp("daty").setLibelle("Date");
        pi.getFormu().getChamp("etat").setVisible(false);
        pi.getFormu().getChamp("etat").setDefaut("1");

        pi.getFormufle().getChamp("reference_0").setLibelle("R&eacute;f&eacute;rence");
        pi.getFormufle().getChamp("credit_0").setLibelle("Montant");
        pi.getFormufle().getChamp("idorigine_0").setLibelle("Origine");
        pi.getFormufle().getChamp("compte_0").setLibelle("Compte");
        pi.getFormufle().getChamp("debit_0").setLibelle("Debit");

        String [] ordre = new String[] {"daty","designation","idtiers","credit","idorigine"};
        pi.getFormu().setOrdre(ordre);


        pi.getFormufle().getChamp("iddevise_0").setLibelle("Devise");
        pi.getFormufle().getChamp("idcaisse_0").setLibelle("Caisse");

        pi.getFormufle().getChamp("idModePaiement_0").setLibelle("Mode de Paiement");


        affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idcaisse"), "caisse.Caisse", "id", "caisse", "", "");

        String[] champsCaches = {"daty", "id", "etat", "idorigine", "designation", "debit", "taux", "idtiers",
                "idventedetail", "idvirement", "idop", "etatversement", "idprevision", "idtraite", "idmvtcaissemere", "iddevise", "compte",  "iduser", "heure"};
        for (String c : champsCaches) Champ.setVisible(pi.getFormufle().getChampFille(c), false);

        String [] ordreFille = { "idCaisse", "idModePaiement","credit", "reference",};
        pi.getFormufle().setColOrdre(ordreFille);

        for (int i = 0; i < nombreLigne; i++) {
            pi.getFormufle().getChamp("etat_" + i).setDefaut("1");
            pi.getFormufle().getChamp("taux_" + i).setDefaut("1");
            pi.getFormufle().getChamp("designation_" + i).setDefaut("Paiement " + origine +" ");
            pi.getFormufle().getChamp("iddevise_" + i).setDefaut("AR");
        }

        pi.preparerDataFormu();
        pi.getFormu().makeHtmlInsertTabIndex();
        pi.getFormufle().makeHtmlInsertTableauIndex();
%>
<div class="content-wrapper">
    <h1>Saisie des mouvements de caisse</h1>
    <form class='container' action="<%=pi.getLien()%>?but=apresMultiple.jsp" method="post">
        <%
            out.println(pi.getFormu().getHtmlInsert());
            out.println(pi.getFormufle().getHtmlTableauInsert());
        %>

        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="bute" type="hidden" id="bute" value="<%=butApresPost%>">
        <input name="classe" type="hidden" id="classe" value="<%=classeMere%>">
        <input name="classefille" type="hidden" id="classefille" value="<%=classeFille%>">
        <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%=nombreLigne%>">
        <input name="colonneMere" type="hidden" id="colonneMere" value="<%=colonneMere%>">
    </form>
</div>


<script>
    document.addEventListener("DOMContentLoaded", function() {
        const mereDate = document.querySelector('input[name="daty"]');
        if (mereDate) {
            mereDate.addEventListener("change", function() {
                const newDate = mereDate.value;
                document.querySelectorAll('input[name^="daty_"]').forEach(input => {
                    input.value = newDate;
                });
            });
        }

        const mereModePaiement = document.querySelector('select[name="idmodepaiement"], input[name="idmodepaiement"]');
        if (mereModePaiement) {
            const majFilles = () => {
                const newValue = mereModePaiement.value;
                const filles = document.querySelectorAll('input[name^="idmodepaiement_"], input[name^="idModePaiement_"], select[name^="idmodepaiement_"]');
                filles.forEach(input => {
                    input.value = newValue;
                });
            };
            mereModePaiement.addEventListener("change", majFilles);
            majFilles();
        }

        const mereDesignation = document.querySelector('input[name="designation"]');
        const refsFilles = document.querySelectorAll('input[name^="reference_"]');
        const majDesignation = () => {
            if (!mereDesignation) return;
            const concat = Array.from(refsFilles)
                .map(r => r.value.trim())
                .filter(v => v !== "")
                .join("_");
            mereDesignation.value = concat;
        };
        refsFilles.forEach(r => {
            r.addEventListener("keyup", majDesignation);
            r.addEventListener("change", majDesignation);
        });
        majDesignation();
    });
</script>

<%
} catch (Exception e) {
    e.printStackTrace();
%>
<script>
    alert('<%=e.getMessage()%>');
    history.back();
</script>
<%
    }
%>

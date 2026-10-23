<%@ page import="mg.cnaps.compta.BilanCompte" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="mg.cnaps.compta.LigneBilan" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="bean.AdminGen" %>
<%
    try{
        String typeetat = request.getParameter("typeetat");
        String annee = request.getParameter("annee");
        BilanCompte bilanCompte = new BilanCompte(typeetat,annee);
        LigneBilan[] nonactifs = Arrays.copyOfRange(bilanCompte.getLigneBilan(),0,15);
        LigneBilan[] actifs = Arrays.copyOfRange(bilanCompte.getLigneBilan(),15,24);

%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Bilan Actif</title>
    <style>
        :root{
            --border:#444;
            --muted:#666;
            --bg:#fff;
            --accent:#111;
        }
        *{box-sizing:border-box}
        body{
            font-family: "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            background: var(--bg);
            color:#111; margin:0; padding:24px;
        }
        .page{
            max-width: 900px; margin: 0 auto; background:#fff;
        }
        h1,h2,h3{margin:0}
        header{ text-align:center; margin-bottom:18px; }
        header h1{ font-size:22px; letter-spacing:.5px; }
        header .subtitle{ color:var(--muted); margin-top:6px; }
        .meta{
            display:flex; justify-content:space-between; margin:12px 0 18px; color:var(--muted); font-size:14px;
        }
        /* Table */
        table{ width:100%; border-collapse:collapse; }
        th, td{ border:1px solid var(--border); padding:8px 10px; vertical-align:top; }
        thead th{ background:#f3f3f3; text-align:center; font-weight:600; }
        .group-title{
            background:#f7f7f7; font-weight:700;
        }
        .right{ text-align:right; }
        .mono{ font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, "Liberation Mono", monospace; }
        .muted{ color:var(--muted); }
        .nowrap{ white-space:nowrap; }
        tfoot td{
            font-weight:700; background:#fafafa;
        }
        /* Print */
        @media print{
            body{ padding:0 }
            .page{ width:100%; max-width:none; }
            a[href]:after{ content:""; }
        }
    </style>
</head>
<body>

<div class="content-wrapper">

    <table aria-label="Bilan Actif">
        <h1>BILAN ACTIF de <%= annee%></h1>
        <!--div class="subtitle">Exercice clos le&nbsp;: <span class="mono">____ / ____ / ______</span></div-->
        <div class="muted">Unit&eacute; mon&eacute;taire&nbsp;: Ariary</div>
        <thead>
        <tr>
            <th rowspan="2" style="width:36%">POSTES D&apos;ACTIF</th>
            <th colspan="3" style="width:64%">COMPTES</th>
        </tr>
        <tr>
            <th style="width:22%">Montants bruts</th>
            <th style="width:21%">Amort/perte de valeur</th>
            <th style="width:21%">Montant net</th>
        </tr>
        </thead>

        <tbody>
        <% if (bilanCompte.isSansEcriture()) { %>
        <tr><td colspan="4" style="text-align:center; font-style:italic; color:var(--muted);">Aucune donn&eacute;e disponible pour l&apos;exercice <%= annee %></td></tr>
        <% } %>
        <!-- ACTIFS NON COURANTS -->
        <tr><td class="group-title" colspan="4">ACTIFS NON COURANTS</td></tr>

        <tr>
            <td>&Eacute;cart d&apos;acquisition (ou goodwill)</td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[0].getValeur1()) %></td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[0].getValeur2()) %></td>
        <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[0].getValeur1() - bilanCompte.getLigneBilan()[0].getValeur2()) %></td>
        </tr>

        <tr>
            <td>Immobilisations incorporelles<br><span class="muted">Frais de d&eacute;veloppement immobilier</span></td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[1].getValeur1()) %></td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[1].getValeur2()) %></td>
        <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[1].getValeur1() - bilanCompte.getLigneBilan()[1].getValeur2()) %></td>
        </tr>
        <tr>
            <td><span class="muted">Concessions, brevets, licences, logiciels et valeurs similaires</span></td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[2].getValeur1()) %></td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[2].getValeur2()) %></td>
        <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[2].getValeur1() - bilanCompte.getLigneBilan()[2].getValeur2()) %></td>
        </tr>
        <tr>
            <td><span class="muted">Autres</span></td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[3].getValeur1()) %></td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[3].getValeur2()) %></td>
        <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[3].getValeur1() - bilanCompte.getLigneBilan()[3].getValeur2()) %></td>
        </tr>

        <tr>
            <td>Immobilisations corporelles<br><span class="muted">Terrains</span></td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[4].getValeur1()) %></td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[4].getValeur2()) %></td>
        <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[4].getValeur1() - bilanCompte.getLigneBilan()[4].getValeur2()) %></td>
        </tr>
        <tr>
            <td><span class="muted">Construction</span></td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[5].getValeur1()) %></td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[5].getValeur2()) %></td>
        <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[5].getValeur1() - bilanCompte.getLigneBilan()[5].getValeur2()) %></td>
        </tr>
        <tr>
            <td><span class="muted">Installation technique</span></td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[6].getValeur1()) %></td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[6].getValeur2()) %></td>
        <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[6].getValeur1() - bilanCompte.getLigneBilan()[6].getValeur2()) %></td>
        </tr>
        <tr>
            <td><span class="muted">Autres</span></td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[7].getValeur1()) %></td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[7].getValeur2()) %></td>
        <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[7].getValeur1() - bilanCompte.getLigneBilan()[7].getValeur2()) %></td>
        </tr>

        <tr>
            <td>Immobilisation mise en concession</td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[8].getValeur1()) %></td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[8].getValeur2()) %></td>
        <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[8].getValeur1() - bilanCompte.getLigneBilan()[8].getValeur2()) %></td>
        </tr>
        <tr>
            <td>Immobilisations en cours</td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[9].getValeur1()) %></td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[9].getValeur2()) %></td>
        <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[9].getValeur1() - bilanCompte.getLigneBilan()[9].getValeur2()) %></td>
        </tr>

        <tr>
            <td>Immobilisations financi&egrave;res<br><span class="muted">Titres mis en &eacute;quivalence</span></td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[10].getValeur1()) %></td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[10].getValeur2()) %></td>
        <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[10].getValeur1() - bilanCompte.getLigneBilan()[10].getValeur2()) %></td>
        </tr>
        <tr>
            <td><span class="muted">Autres participations et cr&eacute;ances rattach&eacute;es</span></td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[11].getValeur1()) %></td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[11].getValeur2()) %></td>
        <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[11].getValeur1() - bilanCompte.getLigneBilan()[11].getValeur2()) %></td>
        </tr>
        <tr>
            <td><span class="muted">Autres titres immobilis&eacute;s</span></td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[12].getValeur1()) %></td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[12].getValeur2()) %></td>
        <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[12].getValeur1() - bilanCompte.getLigneBilan()[12].getValeur2()) %></td>
        </tr>
        <tr>
            <td><span class="muted">Pr&ecirc;ts et autres immobilisations financi&egrave;res</span></td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[13].getValeur1()) %></td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[13].getValeur2()) %></td>
        <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[13].getValeur1() - bilanCompte.getLigneBilan()[13].getValeur2()) %></td>
        </tr>

        <tr>
            <td>Imp&ocirc;ts diff&eacute;r&eacute;s actifs &mdash; non courants</td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[14].getValeur1()) %></td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[14].getValeur2()) %></td>
        <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[14].getValeur1() - bilanCompte.getLigneBilan()[14].getValeur2()) %></td>
        </tr>

        <tr>
            <td class="right"><strong>TOTAL ACTIFS NON COURANTS</strong></td>
            <td class="mono right"><strong><%=Utilitaire.formaterAr(AdminGen.calculSommeDouble(nonactifs,"valeur1"))%></strong></td>
            <td class="mono right"><strong><%=Utilitaire.formaterAr(AdminGen.calculSommeDouble(nonactifs,"valeur2"))%></strong></td>
        <td class="mono right"><strong><%=Utilitaire.formaterAr(AdminGen.calculSommeDouble(nonactifs,"valeur1") - AdminGen.calculSommeDouble(nonactifs,"valeur2"))%></strong></td>
        </tr>

        <!-- ACTIFS COURANTS -->
        <tr><td class="group-title" colspan="4">ACTIFS COURANTS</td></tr>

        <tr>
            <td>Stocks et en cours<br><span class="muted">Mati&egrave;re premi&egrave;re</span></td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[15].getValeur1()) %></td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[15].getValeur2()) %></td>
        <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[15].getValeur1() - bilanCompte.getLigneBilan()[15].getValeur2()) %></td>
        </tr>
        <tr>
            <td><span class="muted">En cours de production</span></td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[16].getValeur1()) %></td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[16].getValeur2()) %></td>
        <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[16].getValeur1() - bilanCompte.getLigneBilan()[16].getValeur2()) %></td>
        </tr>
        <tr>
            <td><span class="muted">Produits finis</span></td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[17].getValeur1()) %></td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[17].getValeur2()) %></td>
        <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[17].getValeur1() - bilanCompte.getLigneBilan()[17].getValeur2()) %></td>
        </tr>
        <tr>
            <td><span class="muted">Marchandises</span></td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[18].getValeur1()) %></td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[18].getValeur2()) %></td>
        <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[18].getValeur1() - bilanCompte.getLigneBilan()[18].getValeur2()) %></td>
        </tr>
        <tr>
            <td><span class="muted">&Agrave; l&apos;ext&eacute;rieur</span></td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[19].getValeur1()) %></td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[19].getValeur2()) %></td>
        <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[19].getValeur1() - bilanCompte.getLigneBilan()[19].getValeur2()) %></td>
        </tr>

        <tr>
            <td>Cr&eacute;ances et emplois assimil&eacute;s<br><span class="muted">Clients et autres d&eacute;biteurs</span></td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[20].getValeur1()) %></td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[20].getValeur2()) %></td>
        <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[20].getValeur1() - bilanCompte.getLigneBilan()[20].getValeur2()) %></td>
        </tr>
        <tr>
            <td><span class="muted">Autres cr&eacute;ances et actifs assimil&eacute;s</span></td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[21].getValeur1()) %></td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[21].getValeur2()) %></td>
        <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[21].getValeur1() - bilanCompte.getLigneBilan()[21].getValeur2()) %></td>
        </tr>

        <tr>
            <td>Tr&eacute;sorerie et &eacute;quivalents de tr&eacute;sorerie<br>
                <span class="muted">Placements et autres &eacute;quivalents de tr&eacute;sorerie</span>
            </td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[22].getValeur1()) %></td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[22].getValeur2()) %></td>
        <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[22].getValeur1() - bilanCompte.getLigneBilan()[22].getValeur2()) %></td>
        </tr>
        <tr>
            <td><span class="muted">Tr&eacute;sorerie (fonds en caisse et d&eacute;p&ocirc;ts &agrave; vue)</span></td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[23].getValeur1()) %></td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[23].getValeur2()) %></td>
        <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[23].getValeur1() - bilanCompte.getLigneBilan()[23].getValeur2()) %></td>
        </tr>

        <tr>
            <td class="right"><strong>TOTAL ACTIFS COURANTS</strong></td>
            <td class="mono right"><strong><%=Utilitaire.formaterAr(AdminGen.calculSommeDouble(actifs,"valeur1"))%></strong></td>
            <td class="mono right"><strong><%=Utilitaire.formaterAr(AdminGen.calculSommeDouble(actifs,"valeur2"))%></strong></td>
        <td class="mono right"><strong><%=Utilitaire.formaterAr(AdminGen.calculSommeDouble(actifs,"valeur1") - AdminGen.calculSommeDouble(actifs,"valeur2"))%></strong></td>
        </tr>
        </tbody>
        <tfoot>
        <tr>
            <td class="right">TOTAL DES ACTIFS</td>
            <td class="mono right"><strong><%=Utilitaire.formaterAr(AdminGen.calculSommeDouble(bilanCompte.getLigneBilan(),"valeur1"))%></strong></td>
            <td class="mono right"><strong><%=Utilitaire.formaterAr(AdminGen.calculSommeDouble(bilanCompte.getLigneBilan(),"valeur2"))%></strong></td>
        <td class="mono right"><strong><%=Utilitaire.formaterAr(AdminGen.calculSommeDouble(bilanCompte.getLigneBilan(),"valeur1") - AdminGen.calculSommeDouble(bilanCompte.getLigneBilan(),"valeur2"))%></strong></td>
        </tr>
        </tfoot>
    </table>
</div>
</body>
</html>
<%
} catch (Exception e) {
    e.printStackTrace();
} %>
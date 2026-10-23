<%@ page import="mg.cnaps.compta.BilanCompte" %>
<%@ page import="mg.cnaps.compta.LigneBilan" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="utilitaire.Utilitaire" %>
<%
    try{
    String typeetat = request.getParameter("typeetat");
    String annee = request.getParameter("annee");
    BilanCompte bilanCompte = new BilanCompte(typeetat,annee);

%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Compte de R&eacute;sultat (par nature)</title>
    <style>
        :root{
            --border:#444;
            --muted:#666;
            --bg:#fff;
        }
        *{box-sizing:border-box}
        body{
            font-family: "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            background: var(--bg);
            color:#111; margin:0; padding:24px;
        }
        .page{ max-width: 950px; margin: 0 auto; background:#fff; }
        h1,h2,h3{margin:0}
        header{ text-align:center; margin-bottom:18px; }
        header h1{ font-size:22px; letter-spacing:.5px; }
        header .subtitle{ color:var(--muted); margin-top:6px; font-size:14px; }
        table{ width:100%; border-collapse:collapse; }
        th, td{ border:1px solid var(--border); padding:6px 8px; vertical-align:top; }
        thead th{ background:#f3f3f3; text-align:center; font-weight:600; }
        .group-title{ background:#f7f7f7; font-weight:700; }
        .right{ text-align:right; }
        .mono{ font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace; }
        .muted{ color:var(--muted); }
        tfoot td{ font-weight:700; background:#fafafa; }
        @media print{
            body{ padding:0 }
            .page{ width:100%; max-width:none; }
        }
        .mono{
            text-align: end;
        }
    </style>
</head>
<body>
<div class="content-wrapper">
    <header>
        <h1>COMPTE DE RESULTAT<br>(par nature) DE <%=annee%></h1>
        <!--div class="subtitle">Unit&eacute; mon&eacute;taire&nbsp;: Ariary &nbsp;&nbsp; P&eacute;riode du ____ au ____</div-->
    </header>

    <table aria-label="Compte de R&eacute;sultat">
        <thead>
        <tr>
            <th rowspan="2" style="width:50%">POSTES</th>
            <th colspan="2" style="width:50%">MONTANT</th>
        </tr>
        </thead>
        <tbody>
        <% if (bilanCompte.isSansEcriture()) { %>
        <tr><td colspan="3" style="text-align:center; font-style:italic; color:var(--muted);">Aucune donn&eacute;e disponible pour l&apos;exercice <%= annee %></td></tr>
        <% } %>
        <tr><td>Chiffre d&#39;affaires</td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[0].getValeur1()-bilanCompte.getLigneBilan()[0].getValeur2()) %></td>
        </tr>
        <tr><td>Production stock&eacute;e</td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[1].getValeur1()-bilanCompte.getLigneBilan()[1].getValeur2()) %></td>
        </tr>
        <tr><td>Production immobilis&eacute;e</td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[2].getValeur1()-bilanCompte.getLigneBilan()[2].getValeur2()) %></td>
        </tr>

        <tr class="group-title"><td>I - Production de l&#39;exercice</td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[3].getValeur1()-bilanCompte.getLigneBilan()[3].getValeur2()) %></td>
        </tr>

        <tr><td>Achats consomm&eacute;s</td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[4].getValeur1()-bilanCompte.getLigneBilan()[4].getValeur2()) %></td>
        </tr>
        <tr><td>Services ext&eacute;rieurs et autres consommations</td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[5].getValeur1()-bilanCompte.getLigneBilan()[5].getValeur2()) %></td>
        </tr>

        <tr class="group-title"><td>II - Consommation de l&#39;exercice</td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[6].getValeur1()-bilanCompte.getLigneBilan()[6].getValeur2()) %></td>
        </tr>
        <tr class="group-title"><td>III - VALEUR AJOUTEE D&#39;EXPLOITATION (I - II)</td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[7].getValeur1()-bilanCompte.getLigneBilan()[7].getValeur2()) %></td>
        </tr>

        <tr><td>Subvention d&#39;exploitation</td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[8].getValeur1()-bilanCompte.getLigneBilan()[8].getValeur2()) %></td>
        </tr>
        <tr><td>Charges de personnel (A)</td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[9].getValeur1()-bilanCompte.getLigneBilan()[9].getValeur2()) %></td>
        </tr>
        <tr><td>Imp&ocirc;ts, taxes et versements assimil&eacute;s</td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[10].getValeur1()-bilanCompte.getLigneBilan()[10].getValeur2()) %></td>
        </tr>

        <tr class="group-title"><td>IV - EXCEDENT BRUT D&#39;EXPLOITATION</td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[11].getValeur1()-bilanCompte.getLigneBilan()[11].getValeur2()) %></td>
        </tr>

        <tr><td>Autres produits op&eacute;rationnels</td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[12].getValeur1()-bilanCompte.getLigneBilan()[12].getValeur2()) %></td>
        </tr>
        <tr><td>Autres charges op&eacute;rationnelles</td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[13].getValeur1()-bilanCompte.getLigneBilan()[13].getValeur2()) %></td>
        </tr>
        <tr><td>Dotations aux amortissements, provisions et pertes de valeur</td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[14].getValeur1()-bilanCompte.getLigneBilan()[14].getValeur2()) %></td>
        </tr>
        <tr><td>Reprise sur provisions et pertes de valeurs</td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[15].getValeur1()-bilanCompte.getLigneBilan()[15].getValeur2()) %></td>
        </tr>

        <tr class="group-title"><td>V - RESULTAT OPERATIONNEL</td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[16].getValeur1()-bilanCompte.getLigneBilan()[16].getValeur2()) %></td>
        </tr>
        <tr><td>Produits financiers</td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[17].getValeur1()-bilanCompte.getLigneBilan()[17].getValeur2()) %></td>
        </tr>
        <tr><td>Charges financi&egrave;res</td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[18].getValeur1()-bilanCompte.getLigneBilan()[18].getValeur2()) %></td>
        </tr>

        <tr class="group-title"><td>VI - RESULTAT FINANCIER</td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[19].getValeur1()-bilanCompte.getLigneBilan()[19].getValeur2()) %></td>
        </tr>
        <tr class="group-title"><td>VII - RESULTAT AVANT IMPOTS (V + VI)</td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[20].getValeur1()-bilanCompte.getLigneBilan()[20].getValeur2()) %></td>
        </tr>
        <tr><td>Imp&ocirc;ts exigibles sur r&eacute;sultats</td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[21].getValeur1()-bilanCompte.getLigneBilan()[21].getValeur2()) %></td>
        </tr>
        <tr><td>Imp&ocirc;ts diff&eacute;r&eacute;s (Variations)</td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[22].getValeur1()-bilanCompte.getLigneBilan()[22].getValeur2()) %></td>
        </tr>

        <tr class="group-title"><td colspan="3">TOTAL DES PRODUITS DES ACTIVITES ORDINAIRES</td></tr>
        <tr class="group-title"><td colspan="3">TOTAL DES CHARGES DES ACTIVITES ORDINAIRES</td></tr>

        <tr class="group-title"><td>VIII - RESULTAT NET DES ACTIVITES ORDINAIRES</td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[23].getValeur1()-bilanCompte.getLigneBilan()[23].getValeur2()) %></td>
        </tr>
        <tr><td>&Eacute;l&eacute;ments extraordinaires (produits)</td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[24].getValeur1()-bilanCompte.getLigneBilan()[24].getValeur2()) %></td>
        </tr>
        <tr><td>&Eacute;l&eacute;ments extraordinaires (charges)</td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[25].getValeur1()-bilanCompte.getLigneBilan()[25].getValeur2()) %></td>
        </tr>

        <tr class="group-title"><td>IX - RESULTAT EXTRAORDINAIRE</td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[26].getValeur1()-bilanCompte.getLigneBilan()[26].getValeur2()) %></td>
        </tr>
        <tr class="group-title"><td>X - RESULTAT NET DE L&#39;EXERCICE</td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[27].getValeur1()-bilanCompte.getLigneBilan()[27].getValeur2()) %></td>
        </tr>
        <tr><td>Dont r&eacute;sultats nets des soci&eacute;t&eacute;s mises en &eacute;quivalence (1)</td><td colspan="2"></td></tr>
        <tr class="group-title"><td colspan="3">XI - RESULTAT NET DE L&#39;ENSEMBLE CONSOLIDE</td></tr>
        <tr><td>Dont part des minoritaires (1)</td><td colspan="2"></td></tr>
        <tr><td>Part du groupe (1)</td><td colspan="2"></td></tr>
        </tbody>
    </table>
</div>
</body>
</html>
<%
} catch (Exception e) {
    e.printStackTrace();
} %>
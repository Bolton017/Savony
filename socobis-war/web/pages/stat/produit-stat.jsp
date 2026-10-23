<%@ page import="java.util.List" %>
<%@ page import="java.util.Arrays" %>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>

<%
    List<Double> liste = Arrays.asList (
            12.0, 19.0, 13.0, 15.0, 22.0, 30.0,
            28.0, 35.0, 40.0, 45.0, 42.0, 50.0
    );
%>

<div class="content-wrapper">
    <div class="row">
        <div class="col-md-12">
            <canvas id="myLineChart"></canvas>
        </div>
    </div>
</div>

<script>
    const ctx = document.getElementById('myLineChart').getContext('2d');

    const data = {
        labels: [
            'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
            'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'
        ],
        datasets: [
            {
                label: 'Produit A',
                data: [12, 19, 13, 15, 22, 30, 28, 35, 40, 45, 42, 50],
                borderColor: 'rgba(75, 192, 192, 1)',
                backgroundColor: 'rgba(75, 192, 192, 0.2)',
                fill: false,
                tension: 0.3
            },
            {
                label: 'Produit B',
                data: [8, 11, 17, 14, 20, 26, 32, 30, 36, 38, 41, 47],
                borderColor: 'rgba(255, 99, 132, 1)',
                backgroundColor: 'rgba(255, 99, 132, 0.2)',
                fill: false,
                tension: 0.3
            },
            {
                label: 'Produit C',
                data: [5, 9, 12, 18, 21, 25, 29, 33, 31, 37, 39, 43],
                borderColor: 'rgba(54, 162, 235, 1)',
                backgroundColor: 'rgba(54, 162, 235, 0.2)',
                fill: false,
                tension: 0.3
            }
        ]
    };

    const config = {
        type: 'line',
        data: data,
        options: {
            responsive: true,
            plugins: {
                title: {
                    display: true,
                    text: 'Évolution des Produits (%)'
                },
                tooltip: {
                    mode: 'index',
                    intersect: false
                },
                legend: {
                    position: 'top'
                }
            },
            interaction: {
                mode: 'nearest',
                axis: 'x',
                intersect: false
            },
            scales: {
                x: {
                    title: {
                        display: true,
                        text: 'Mois'
                    }
                },
                y: {
                    beginAtZero: true,
                    title: {
                        display: true,
                        text: 'Pourcentage (%)'
                    }
                }
            }
        }
    };

    new Chart(ctx, config);
</script>

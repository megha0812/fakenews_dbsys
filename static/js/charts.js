function readJsonAttribute(element, key) {
    const value = element.getAttribute(key);
    return value ? JSON.parse(value) : [];
}

document.addEventListener("DOMContentLoaded", () => {
    const statusChartEl = document.getElementById("statusChart");
    if (statusChartEl) {
        const real = Number(statusChartEl.dataset.real || 0);
        const fake = Number(statusChartEl.dataset.fake || 0);
        const unverified = Number(statusChartEl.dataset.unverified || 0);
        new Chart(statusChartEl, {
            type: "pie",
            data: {
                labels: ["Real", "Fake", "Unverified"],
                datasets: [{
                    data: [real, fake, unverified],
                    backgroundColor: ["#54d39d", "#ff7474", "#ffc76a"],
                    borderWidth: 0,
                }],
            },
            options: {
                plugins: {
                    legend: {
                        labels: {
                            color: getComputedStyle(document.documentElement).getPropertyValue("--text"),
                        },
                    },
                },
            },
        });
    }

    const categoryChartEl = document.getElementById("categoryChart");
    if (categoryChartEl) {
        const labels = readJsonAttribute(categoryChartEl, "data-labels");
        const values = readJsonAttribute(categoryChartEl, "data-values");
        new Chart(categoryChartEl, {
            type: "bar",
            data: {
                labels,
                datasets: [{
                    label: "News Count",
                    data: values,
                    borderRadius: 12,
                    backgroundColor: ["#56b6ff", "#54d39d", "#ffc76a", "#7e8cff", "#ff7474"],
                }],
            },
            options: {
                scales: {
                    x: {
                        ticks: {
                            color: getComputedStyle(document.documentElement).getPropertyValue("--muted"),
                        },
                        grid: {
                            display: false,
                        },
                    },
                    y: {
                        beginAtZero: true,
                        ticks: {
                            color: getComputedStyle(document.documentElement).getPropertyValue("--muted"),
                        },
                        grid: {
                            color: "rgba(255,255,255,0.08)",
                        },
                    },
                },
                plugins: {
                    legend: {
                        display: false,
                    },
                },
            },
        });
    }
});

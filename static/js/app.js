const themeToggle = document.getElementById("theme-toggle");
const root = document.documentElement;
const lockFeedback = document.getElementById("lock-feedback");

function setTheme(theme) {
    root.setAttribute("data-theme", theme);
    localStorage.setItem("nvs-theme", theme);
    if (themeToggle) {
        const icon = themeToggle.querySelector("i");
        const label = themeToggle.querySelector("span");
        if (icon && label) {
            icon.className = theme === "dark" ? "fa-solid fa-moon" : "fa-solid fa-sun";
            label.textContent = theme === "dark" ? "Toggle Theme" : "Toggle Theme";
        }
    }
}

function animateCounters() {
    document.querySelectorAll(".counter").forEach((counter) => {
        const target = Number(counter.dataset.target || 0);
        const decimals = String(counter.dataset.target || "").includes(".") ? 1 : 0;
        const duration = 1000;
        const startTime = performance.now();

        function tick(now) {
            const progress = Math.min((now - startTime) / duration, 1);
            const value = target * (1 - Math.pow(1 - progress, 3));
            counter.textContent = value.toFixed(decimals);
            if (progress < 1) {
                requestAnimationFrame(tick);
            }
        }

        requestAnimationFrame(tick);
    });
}

async function postJson(url) {
    const response = await fetch(url, {
        method: "POST",
        headers: {
            "X-Requested-With": "XMLHttpRequest",
        },
    });
    return response.json();
}

function attachLockActions() {
    document.querySelectorAll(".lock-action").forEach((button) => {
        button.addEventListener("click", async () => {
            const newsId = button.dataset.newsId;
            const payload = await postJson(`/verification/lock/${newsId}`);
            if (lockFeedback) {
                lockFeedback.textContent = payload.message;
            }
        });
    });

    document.querySelectorAll(".unlock-action").forEach((button) => {
        button.addEventListener("click", async () => {
            const newsId = button.dataset.newsId;
            const payload = await postJson(`/verification/unlock/${newsId}`);
            if (lockFeedback) {
                lockFeedback.textContent = payload.message;
            }
        });
    });

    document.querySelectorAll(".test-lock-action").forEach((button) => {
        button.addEventListener("click", async () => {
            const newsId = button.dataset.newsId;
            const payload = await postJson(`/verification/check-lock/${newsId}`);
            if (lockFeedback) {
                lockFeedback.textContent = payload.message;
            }
        });
    });
}

document.addEventListener("DOMContentLoaded", () => {
    const savedTheme = localStorage.getItem("nvs-theme") || "dark";
    setTheme(savedTheme);
    animateCounters();
    attachLockActions();

    if (themeToggle) {
        themeToggle.addEventListener("click", () => {
            const nextTheme = root.getAttribute("data-theme") === "dark" ? "light" : "dark";
            setTheme(nextTheme);
        });
    }
});

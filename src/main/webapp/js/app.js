/**
 * Interactive Frontend JavaScript for Training Institute Management System
 */

document.addEventListener("DOMContentLoaded", () => {
    // 1. Initialize Modals
    setupModals();

    // 2. Initialize AJAX Search Bar if active
    setupAjaxSearch();

    // 3. Circular Photo Preview Trigger
    setupPhotoPreview();

    // 4. Initialize Chart.js Dashboards
    initCharts();
});

// Setup Modals toggles
function setupModals() {
    const triggers = document.querySelectorAll("[data-modal]");
    triggers.forEach(trigger => {
        trigger.addEventListener("click", () => {
            const modalId = trigger.getAttribute("data-modal");
            const modal = document.getElementById(modalId);
            if (modal) {
                modal.classList.add("active");
            }
        });
    });

    const closeButtons = document.querySelectorAll(".close-modal");
    closeButtons.forEach(btn => {
        btn.addEventListener("click", () => {
            const overlay = btn.closest(".modal-overlay");
            if (overlay) {
                overlay.classList.remove("active");
            }
        });
    });
}

// AJAX dynamic search directory lists
function setupAjaxSearch() {
    const searchBar = document.getElementById("directorySearch");
    if (!searchBar) return;

    const type = searchBar.getAttribute("data-search-type"); // "student" or "course"
    const resultsContainer = document.getElementById("directoryResults");

    searchBar.addEventListener("input", debounce((e) => {
        const query = e.target.value;
        const contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf("/", 2)) || "";

        fetch(`${contextPath}/api/search?q=${encodeURIComponent(query)}&type=${type}`)
            .then(res => res.json())
            .then(data => {
                if (type === "student") {
                    renderStudentRows(data, resultsContainer, contextPath);
                } else if (type === "course") {
                    renderCourseRows(data, resultsContainer, contextPath);
                }
            })
            .catch(err => console.error("Search failed:", err));
    }, 300));
}

// Debounce helper to prevent heavy fetch querying
function debounce(func, wait) {
    let timeout;
    return function (...args) {
        clearTimeout(timeout);
        timeout = setTimeout(() => func.apply(this, args), wait);
    };
}

// Render dynamic student rows
function renderStudentRows(students, container, contextPath) {
    container.innerHTML = "";
    if (students.length === 0) {
        container.innerHTML = `<tr><td colspan="6" style="text-align: center; color: var(--text-muted);">No students found</td></tr>`;
        return;
    }

    students.forEach(s => {
        const tr = document.createElement("tr");
        tr.style.opacity = 0;
        tr.style.transition = "opacity 0.3s ease";
        
        const photoHtml = s.photoPath 
            ? `<img src="${contextPath}/${s.photoPath}" class="avatar-frame" alt="${s.studentName}">`
            : `<div class="avatar-placeholder">${s.studentName.charAt(0)}</div>`;

        tr.innerHTML = `
            <td>${s.studentId}</td>
            <td>
                <div style="display: flex; align-items: center; gap: 0.75rem;">
                    ${photoHtml}
                    <span style="font-weight: 500;">${s.studentName}</span>
                </div>
            </td>
            <td>${s.email}</td>
            <td>${s.course}</td>
            <td>${s.phone}</td>
            <td>
                <div style="display: flex; gap: 0.5rem;">
                    <button class="btn btn-secondary btn-sm" onclick="editStudent(${s.studentId}, '${s.studentName}', '${s.email}', '${s.course}', '${s.phone}')">Edit</button>
                    <a href="${contextPath}/students/delete?id=${s.studentId}" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure you want to delete this student?')">Delete</a>
                </div>
            </td>
        `;
        container.appendChild(tr);
        setTimeout(() => tr.style.opacity = 1, 50);
    });
}

// Render dynamic course rows
function renderCourseRows(courses, container, contextPath) {
    container.innerHTML = "";
    if (courses.length === 0) {
        container.innerHTML = `<tr><td colspan="5" style="text-align: center; color: var(--text-muted);">No courses found</td></tr>`;
        return;
    }

    courses.forEach(c => {
        const tr = document.createElement("tr");
        tr.style.opacity = 0;
        tr.style.transition = "opacity 0.3s ease";

        tr.innerHTML = `
            <td>${c.courseId}</td>
            <td style="font-weight: 500;">${c.courseName}</td>
            <td>${c.duration}</td>
            <td>INR ${parseFloat(c.fees).toFixed(2)}</td>
            <td>${c.facultyName}</td>
            <td>
                <div style="display: flex; gap: 0.5rem;">
                    <button class="btn btn-secondary btn-sm" onclick="editCourse(${c.courseId}, '${c.courseName}', '${c.duration}', ${c.fees}, '${c.facultyName}')">Edit</button>
                    <a href="${contextPath}/courses/delete?id=${c.courseId}" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure you want to delete this course?')">Delete</a>
                </div>
            </td>
        `;
        container.appendChild(tr);
        setTimeout(() => tr.style.opacity = 1, 50);
    });
}

// Circular Photo Live Preview
function setupPhotoPreview() {
    const inputs = document.querySelectorAll(".photo-file-input");
    inputs.forEach(input => {
        input.addEventListener("change", (e) => {
            const file = e.target.files[0];
            const targetPreviewId = input.getAttribute("data-preview-target");
            const previewImg = document.getElementById(targetPreviewId);
            
            if (file && previewImg) {
                const reader = new FileReader();
                reader.onload = (event) => {
                    previewImg.src = event.target.result;
                };
                reader.readAsDataURL(file);
            }
        });
    });
}

// Render beautiful Chart.js dashboards if canvas available
function initCharts() {
    const lineCtx = document.getElementById("attendanceChart");
    if (lineCtx) {
        new Chart(lineCtx, {
            type: 'line',
            data: {
                labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'],
                datasets: [{
                    label: 'Overall Class Attendance Rate (%)',
                    data: [82, 85, 80, 94, 88],
                    borderColor: '#6366f1',
                    backgroundColor: 'rgba(99, 102, 241, 0.1)',
                    tension: 0.4,
                    fill: true
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: false }
                },
                scales: {
                    y: { min: 0, max: 100, grid: { color: 'rgba(255,255,255,0.05)' }, ticks: { color: '#a1a1aa' } },
                    x: { grid: { display: false }, ticks: { color: '#a1a1aa' } }
                }
            }
        });
    }

    const doughnutCtx = document.getElementById("courseEnrollmentChart");
    if (doughnutCtx) {
        new Chart(doughnutCtx, {
            type: 'doughnut',
            data: {
                labels: ['Java Full Stack', 'Python Data Science', 'React Mobile'],
                datasets: [{
                    data: [45, 30, 25],
                    backgroundColor: ['#6366f1', '#a855f7', '#fbbf24'],
                    borderWidth: 0
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { position: 'bottom', labels: { color: '#a1a1aa', boxWidth: 12 } }
                }
            }
        });
    }
}

import { createRouter, createWebHistory } from 'vue-router'

import Login from '../views/login/Login.vue'
import Home from '../views/home/Home.vue'

const router = createRouter({
    history: createWebHistory(),
    routes: [
        {
            path: '/',          // 路径
            redirect: '/login'  // 重定向
        },
        {
            path: '/login',     // 路径
            component: Login    // 跳转到的组件
        },
        {
            path: '/index',     // 路径
            component: Home,    // 跳转到的组件
            children:[
                {
                    path: '/index/status_manage',
                    component: () => import('../views/home/StatusManage.vue')
                },
                {
                    path: '/index/student_stat',
                    component: () => import('../views/home/StudentStat.vue')
                },
                {
                    path: '/index/grade_manage',
                    component: () => import('../views/home/GradeManage.vue')
                },
                {
                    path: '/index/semester_grade',
                    component: () => import('../views/home/SemesterGrade.vue')
                },
                {
                    path: '/index/grade_section',
                    component: () => import('../views/home/GradeSection.vue')
                },
                {
                    path: '/index/grade_stat',
                    component: () => import('../views/home/GradeStat.vue')
                }
            ]
        }
    ]
})

// 导航守卫，前置处理
router.beforeEach((to, from, next) => {
    let isAuthenticated = !!localStorage.getItem('username')
    // 如果路由要跳转到除了登录和注册的界面的话就判断是否已经登录，如果没有登录就强制跳到登录界面
    if (to.path !== '/login' && !isAuthenticated) {
        next({ path: '/login' })
    } else next()
})

export default router

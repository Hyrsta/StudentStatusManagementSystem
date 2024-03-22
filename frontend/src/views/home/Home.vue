<template>
    <el-container class="outer">
        <el-aside class="menu">
            <el-menu router="true">
                <el-menu-item index="/index/status_manage">
                    <template #title>学籍管理</template>
                </el-menu-item>
                <el-menu-item index="/index/student_stat" :disabled="username != 'admin'">
                    <template #title>学生统计</template>
                </el-menu-item>
                <el-menu-item index="/index/grade_manage" :disabled="username != 'admin'">
                    <template #title>成绩管理</template>
                </el-menu-item>
                <el-menu-item index="/index/semester_grade" :disabled="username != 'admin'">
                    <template #title>学期成绩统计</template>
                </el-menu-item>
                <el-menu-item index="/index/grade_section" :disabled="username != 'admin'">
                    <template #title>分段成绩统计</template>
                </el-menu-item>
                <el-menu-item index="/index/grade_stat">
                    <template #title>学生成绩统计</template>
                </el-menu-item>
                <el-menu-item @click="logout">
                    <template #title>退出</template>
                </el-menu-item>
            </el-menu>
        </el-aside>
        <el-main>
            <el-scrollbar>
                <RouterView />
            </el-scrollbar>
        </el-main>
    </el-container>
</template>

<script lang="ts" setup>
import router from '@/router';
const username = localStorage.getItem("username")
function logout(){
    localStorage.clear()
    router.push('/login');
}
</script>
  
<style scoped>
.outer {
    width: 93vw;
    height: 100vh;
}

.menu {
    width: 200px;
    top: 100vh;

}
</style>
  
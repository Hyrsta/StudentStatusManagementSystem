<template>
    <el-select v-model="clno" class="m-2" placeholder="Select" size="large">
        <el-option v-for="item in class_options" :key="item.value" :label="item.label" :value="item.value" />
    </el-select>
    <el-select v-model="cno" class="m-2" placeholder="Select" size="large">
        <el-option v-for="item in course_options" :key="item.value" :label="item.label" :value="item.value" />
    </el-select>
    <div v-if="clno != '请选择班级' && cno != '请选择课程'">
        <el-table :data="tableData" :cell-style="{ padding: '4px 0' }">
            <el-table-column prop="sno" label="学号">
                <template v-slot="{ row }">
                    <div class="editable-cell__val">{{ row.sno }}</div>
                </template>
            </el-table-column>
            <el-table-column prop="sname" label="姓名">
                <template v-slot="{ row }">
                    <div class="editable-cell__val">{{ row.sname }}</div>
                </template>
            </el-table-column>
            <el-table-column prop="score" label="成绩">
                <template v-slot="{ row }">
                    <div class="editable-cell__val">{{ row.score }}</div>
                </template>
            </el-table-column>
        </el-table>
    </div>
</template>
<script lang="ts" setup>
import { ref, onMounted, watch } from 'vue'
import axios from 'axios';
import { ElMessage } from 'element-plus'

const clno = ref('请选择班级')
const cno = ref('请选择课程')
const class_options = ref()
const course_options = ref()
const tableData = ref()

onMounted(() => {
    // 获取所有班级
    let username = localStorage.getItem("username")
    let password = localStorage.getItem("password")
    axios({
        url: '/api/get_class',
        method: "get",
        headers: {
            "Content-Type": "application/json",
        },
        params: {
            username: username,
            password: password,
        },
    }).then((res) => {
        if (res.data.code === 0) {
            class_options.value = []
            res.data.data.forEach((item: { clno: string; }) => {
                class_options.value.push({
                    value: item.clno,
                    label: item.clno
                })
            })
        }
        else {
            ElMessage({
                message: res.data.msg,
                type: "error",
            })
        }
    });
    // 获取所有课程
    axios({
        url: '/api/get_course',
        method: "get",
        headers: {
            "Content-Type": "application/json",
        },
        params: {
            username: username,
            password: password,
        },
    }).then((res) => {
        if (res.data.code === 0) {
            course_options.value = []
            res.data.data.forEach((item: { cname: any; cno: any; }) => {
                course_options.value.push({
                    value: item.cno,
                    label: item.cname
                })
            })
        }
        else {
            ElMessage({
                message: res.data.msg,
                type: "error",
            })
        }
    });
})

// 监控班级或课程改变
watch(clno, (clno)=>{refresh(clno, cno.value)})
watch(cno, (cno)=>{refresh(clno.value, cno)})

function refresh(clno, cno) {
    if(clno === '请选择班级' || cno === '请选择课程'){
        return
    }
    let username = localStorage.getItem("username")
    let password = localStorage.getItem("password")
    axios({
        url: '/api/query_grade_class',
        method: "get",
        headers: {
            "Content-Type": "application/json",
        },
        params: {
            username: username,
            password: password,
            clno: clno,
            cno: cno
        },
    }).then((res) => {
        if (res.data.code === 0) {
            console.log(res.data.data)
            tableData.value = res.data.data
        }
        else {
            ElMessage({
                message: res.data.msg,
                type: "error",
            })
        }
    })
}
</script>
<style scoped>
.editable-cell__val {
    box-sizing: border-box;
    height: 32px;
    line-height: 32px;
    border: 1px solid transparent;

    &--hover {
        border-color: #dddddd;
        border-radius: 4px;
        cursor: text;
    }
}
</style>
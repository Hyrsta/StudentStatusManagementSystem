<template>
    <el-select v-model="sno" class="m-2" placeholder="Select" size="large" v-if="username == 'admin'">
        <el-option v-for="item in student_options" :key="item.value" :label="item.label" :value="item.value" />
    </el-select>
    <div v-if="sno != '请选择学生'">
        <el-table :data="tableData" :cell-style="{ padding: '4px 0' }">
            <el-table-column prop="cno" label="课程号">
                <template v-slot="{ row }">
                    <div class="editable-cell__val">{{ row.cno }}</div>
                </template>
            </el-table-column>
            <el-table-column prop="cname" label="课程名称">
                <template v-slot="{ row }">
                    <div class="editable-cell__val">{{ row.cname }}</div>
                </template>
            </el-table-column>
            <el-table-column prop="ccredit" label="学分">
                <template v-slot="{ row }">
                    <div class="editable-cell__val">{{ row.ccredit }}</div>
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

const sno = ref('请选择学生')
const student_options = ref()
const tableData = ref()
const username = localStorage.getItem("username")

onMounted(() => {
    let username = localStorage.getItem("username")
    let password = localStorage.getItem("password")
    if (username != 'admin') {
        sno.value = username
        axios({
            url: '/api/query_grade_student',
            method: "get",
            headers: {
                "Content-Type": "application/json",
            },
            params: {
                username: username,
                password: password,
                sno: username
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
        return
    }
    // 获取所有学生
    axios({
        url: '/api/get_student',
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
            student_options.value = []
            res.data.data.forEach((item: { sname: any; sno: any; }) => {
                student_options.value.push({
                    value: item.sno,
                    label: item.sname
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

// 监控学生改变
watch(sno, function (sno) {
    let username = localStorage.getItem("username")
    let password = localStorage.getItem("password")
    if(username != "admin"){
        return
    }
    axios({
        url: '/api/query_grade_student',
        method: "get",
        headers: {
            "Content-Type": "application/json",
        },
        params: {
            username: username,
            password: password,
            sno: sno
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
})

function refresh(sno) {
    let username = localStorage.getItem("username")
    let password = localStorage.getItem("password")
    // 获取所有学生
    axios({
        url: '/api/get_student',
        method: "get",
        headers: {
            "Content-Type": "application/json",
        },
        params: {
            username: username,
            password: password,
            sno: sno
        },
    }).then((res) => {
        if (res.data.code === 0) {
            student_options.value = []
            res.data.data.forEach((item: { sname: any; sno: any; }) => {
                student_options.value.push({
                    value: item.sno,
                    label: item.sname
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
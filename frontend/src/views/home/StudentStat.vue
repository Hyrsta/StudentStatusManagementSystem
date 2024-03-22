<template>
    <el-select v-model="value" class="m-2" placeholder="Select" size="large">
        <el-option v-for="item in options" :key="item.value" :label="item.label" :value="item.value" />
    </el-select>
    <div v-if="value != '请选择班级'">
        <el-row>
        <el-col :span="12">
            <v-chart class="chart" :option="option1" autoresize/>
        </el-col>
        <el-col :span="12">
            <v-chart class="chart" :option="option2" autoresize />
        </el-col>
    </el-row>
    <el-row>
        <el-col :span="12">
            <v-chart class="chart" :option="option3" autoresize />
        </el-col>
        <el-col :span="12">
            <v-chart class="chart" :option="option4" autoresize />
        </el-col>
    </el-row>
    </div>
</template>
<script lang="ts" setup>
import { ref, onMounted, watch } from 'vue'
import axios from 'axios';
import { ElMessage } from 'element-plus'
import VChart from 'vue-echarts';
import { use } from 'echarts/core'
import { PieChart } from 'echarts/charts'
import {
    TitleComponent,
    TooltipComponent,
    LegendComponent
} from 'echarts/components'
import { CanvasRenderer } from 'echarts/renderers'
use([
    TitleComponent,
    TooltipComponent,
    LegendComponent,
    PieChart,
    CanvasRenderer
])
const option1 = ref({
    title: {
        text: '性别统计',
        left: 'center'
    },
    tooltip: {
        trigger: 'item'
    },
    legend: {
        orient: 'vertical',
        left: 'left'
    },
    series: [
        {
            type: 'pie',
            data: [
                { value: 0, name: '男' },
                { value: 0, name: '女' }
            ],
            emphasis: {
                itemStyle: {
                    shadowBlur: 10,
                    shadowOffsetX: 0,
                    shadowColor: 'rgba(0, 0, 0, 0.5)'
                }
            }
        }
    ]
})
const option2 = ref({
    title: {
        text: '出生年份统计',
        left: 'center'
    },
    tooltip: {
        trigger: 'item'
    },
    legend: {
        orient: 'vertical',
        left: 'left'
    },
    series: [
        {
            type: 'pie',
            data: [],
            emphasis: {
                itemStyle: {
                    shadowBlur: 10,
                    shadowOffsetX: 0,
                    shadowColor: 'rgba(0, 0, 0, 0.5)'
                }
            }
        }
    ]
})
const option3 = ref({
    title: {
        text: '政治面貌统计',
        left: 'center'
    },
    tooltip: {
        trigger: 'item'
    },
    legend: {
        orient: 'vertical',
        left: 'left'
    },
    series: [
        {
            type: 'pie',
            data: [],
            emphasis: {
                itemStyle: {
                    shadowBlur: 10,
                    shadowOffsetX: 0,
                    shadowColor: 'rgba(0, 0, 0, 0.5)'
                }
            }
        }
    ]
})
const option4 = ref({
    title: {
        text: '民族统计',
        left: 'center'
    },
    tooltip: {
        trigger: 'item'
    },
    legend: {
        orient: 'vertical',
        left: 'left'
    },
    series: [
        {
            type: 'pie',
            data: [],
            emphasis: {
                itemStyle: {
                    shadowBlur: 10,
                    shadowOffsetX: 0,
                    shadowColor: 'rgba(0, 0, 0, 0.5)'
                }
            }
        }
    ]
})

const value = ref('请选择班级')
const options = ref()

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
            options.value = []
            res.data.data.forEach((item: { clno: string; }) => {
                options.value.push({
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
})

// 监控班级改变，并更新图标
watch(value, function (clno) {
    let username = localStorage.getItem("username")
    let password = localStorage.getItem("password")
    axios({
        url: '/api/get_class_gender',
        method: "get",
        headers: {
            "Content-Type": "application/json",
        },
        params: {
            username: username,
            password: password,
            clno: clno
        },
    }).then((res) => {
        if (res.data.code === 0) {
            if (res.data.data[0].sgender === '男') {
                option1.value.series[0].data[0].value = res.data.data[0].value
                try {
                    option1.value.series[0].data[1].value = res.data.data[1].value
                }
                catch (e) {
                    option1.value.series[0].data[1].value = 0
                }
            }
            else {
                option1.value.series[0].data[1].value = res.data.data[0].value
                try {
                    option1.value.series[0].data[0].value = res.data.data[1].value
                }
                catch (e) {
                    option1.value.series[0].data[0].value = 0
                }
            }
        }
        else {
            ElMessage({
                message: res.data.msg,
                type: "error",
            })
        }
    });
    axios({
        url: '/api/get_class_birth',
        method: "get",
        headers: {
            "Content-Type": "application/json",
        },
        params: {
            username: username,
            password: password,
            clno: clno
        },
    }).then((res) => {
        if (res.data.code === 0) {
            console.log(res.data.data)
            let data = []
            res.data.data.forEach(element => {
                const date = new Date(element.sbirth)
                const year = date.getFullYear();
                data.push({
                    name: year,
                    value:element.value
                })
            });
            console.log(data)
            option2.value.series[0].data = data
        }
        else {
            ElMessage({
                message: res.data.msg,
                type: "error",
            })
        }
    });
    axios({
        url: '/api/get_class_politic',
        method: "get",
        headers: {
            "Content-Type": "application/json",
        },
        params: {
            username: username,
            password: password,
            clno: clno
        },
    }).then((res) => {
        if (res.data.code === 0) {
            console.log(res.data.data)
            let data = []
            res.data.data.forEach(element => {
                data.push({
                    name: element.spolitic,
                    value:element.value
                })
            });
            console.log(data)
            option3.value.series[0].data = data
        }
        else {
            ElMessage({
                message: res.data.msg,
                type: "error",
            })
        }
    });
    axios({
        url: '/api/get_class_ethnic',
        method: "get",
        headers: {
            "Content-Type": "application/json",
        },
        params: {
            username: username,
            password: password,
            clno: clno
        },
    }).then((res) => {
        if (res.data.code === 0) {
            console.log(res.data.data)
            let data = []
            res.data.data.forEach(element => {
                data.push({
                    name: element.sethnic,
                    value:element.value
                })
            });
            console.log(data)
            option4.value.series[0].data = data
        }
        else {
            ElMessage({
                message: res.data.msg,
                type: "error",
            })
        }
    });
})
</script>
<style scoped>
.chart {
    margin: 50px;
    width: 35vw;
    height: 35vh;
}
</style>
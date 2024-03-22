<template>
    <el-select v-model="clno" class="m-2" placeholder="Select" size="large">
        <el-option v-for="item in class_options" :key="item.value" :label="item.label" :value="item.value" />
    </el-select>
    <el-select v-model="cno" class="m-2" placeholder="Select" size="large">
        <el-option v-for="item in course_options" :key="item.value" :label="item.label" :value="item.value" />
    </el-select>
    <div v-if="clno != '请选择班级' && cno != '请选择课程'">
        <v-chart class="chart" :option="option" autoresize v-if="option.dataset[0].source.length > 0"/>
    </div>
</template>
<script lang="ts" setup>
import { ref, onMounted, watch } from 'vue'
import axios from 'axios';
import { ElMessage } from 'element-plus'
import VChart from 'vue-echarts';
import { use, registerTransform } from 'echarts/core'
import { BarChart } from 'echarts/charts'
import {
  DatasetComponent,
  TooltipComponent,
  GridComponent,
  TransformComponent
} from 'echarts/components'
import { CanvasRenderer } from 'echarts/renderers'
import { transform } from 'echarts-stat';
use([
  DatasetComponent,
  TooltipComponent,
  GridComponent,
  TransformComponent,
  BarChart,
  CanvasRenderer
])
registerTransform(transform.histogram);

const clno = ref('请选择班级')
const cno = ref('请选择课程')
const class_options = ref()
const course_options = ref()
const option = ref({
  dataset: [
    {
      source: [
        [8.3, 143],
        [8.6, 214],
        [8.8, 251],
        [10.5, 26],
        [10.7, 86],
        [10.8, 93],
        [11.0, 176],
        [11.0, 39],
        [11.1, 221],
        [11.2, 188],
        [11.3, 57],
        [11.4, 91],
        [11.4, 191],
        [11.7, 8],
        [12.0, 196],
        [12.9, 177],
        [12.9, 153],
        [13.3, 201],
        [13.7, 199],
        [13.8, 47],
        [14.0, 81],
        [14.2, 98],
        [14.5, 121],
        [16.0, 37],
        [16.3, 12],
        [17.3, 105],
        [17.5, 168],
        [17.9, 84],
        [18.0, 197],
        [18.0, 155],
        [20.6, 125]
      ]
    },
    {
      transform: {
        type: 'ecStat:histogram',
        config: {}
      }
    }
  ],
  tooltip: {},
  grid: [{}
  ],
  xAxis: [
    {
      type: 'category',
      scale: true,
      axisTick: { show: false },
      axisLabel: { show: false },
      axisLine: { show: true },
      gridIndex: 0
    }
  ],
  yAxis: [
    {
      gridIndex: 0
    }
  ],
  series: [
    {
      name: 'histogram',
      type: 'bar',
      xAxisIndex: 0,
      yAxisIndex: 0,
      barWidth: '99.3%',
      label: {
        show: true,
        position: 'top'
      },
      encode: { x: 0, y: 1, itemName: 4 },
      datasetIndex: 1
    }
  ]
})

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
            let data = []
            res.data.data.forEach((element)=>{
                data.push([element.score])
            })
            option.value.dataset[0].source = data
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
.chart {
    margin: 100px;
    width: 60vw;
    height: 50vh;
}
</style>
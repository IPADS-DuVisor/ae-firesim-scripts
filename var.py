class app_var:
    def __init__(self, mode=None, vcpu_nr=0):
        self.mode = mode
        self.vcpu_nr = vcpu_nr
        self.cpu_list = [1, 2, 4]
        self.row_idx = "%s-%d" % (self.mode, self.vcpu_nr)
        self.log_file = "%s-%d.log" % (self.mode, self.vcpu_nr)
        self.raw_data = "app.csv"
        self.apps = ["Memcached", "iperf3", "Netperf", "Hackbench", "Untar", "FileIO", "Prime"]
        
        self.columns = []
        for i in self.apps:
            self.columns.append(i + "-avg")
            self.columns.append(i + "-std")
        
        self.col2idx = {}
        for i in range(len(self.columns)):
            self.col2idx[self.columns[i]] = i

    def cpu_idx(self, cpu):
        for i in range(len(self.cpu_list)):
            if self.cpu_list[i] == cpu:
                return i
        print("ERROR. cpu:%d" % cpu)
        return -1


class micro_var:
    def __init__(self):
        self.raw_data = "micro.csv"
        self.columns = ["cycle"]
        self.role = ["kvm", "duvisor", "vanillakvm"]
        self.micro_bench = {
                "hypercall": ["Exit", "Handling", "Entry"],
                "s2pf": ["Entry/Exit", "GetPage", "Mapping", "Metadata", "Other"],
                "mmio": ["Entry/Exit", "Transfer", "Decode", "Other"],
                "vipi": ["Exit", "vIPI Insert"],
                "vplic": ["vEXT Insert"],
        }
        self.micro_primitive = {}
        # for r in self.role:
        #     for primitive, parts in self.micro_bench.items():
        #         for part in parts:
        #             self.micro_primitive["%s-%s-%s" % (r, primitive, part)] = 0

import torch
from torch.utils.mobile_optimizer import optimize_for_mobile


module._save_for_lite_interpreter("yolo.pt")


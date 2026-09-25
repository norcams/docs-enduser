.. |date| date::

.. _Current GOLD images: nrec-gold-images.html#current-gold-images
.. _How do I set the root password for my Linux instance?: faq.html#how-do-i-set-the-root-password-for-my-linux-instance

Use case toturials
==================

Last changed: |date|

.. contents::

.. note::

    These are highly specific use cases where many choices were made regarding software
    versions, configurations, and tooling. They capture verified working combinations at
    a point in time and will at some point likely become outdated. Treat them as time
    snapshots of successful combinations rather than prescriptive guides.

Infrastructure Basics
=====================

Changing network interface for a running instance
-------------------------------------------------

It is possible to change the network interface (i.e., from dualStack to IPv6)
without rebooting or rebuilding your VM instance. This is possible between all
available networks in the dashboard. Changing network interface will change the IP
addresses of the instance. This toturial demonstrates how to change the network
interface from dualStack to IPv6.

.. TIP::
   **Set root password!**

   It is a good idea to set the root password prior to doing any network changes.
   The instance can then be accessed using the "Console" view in the dashboard.

In the Dashboard:

1. In the drop-down menu of your running instance, select "Detach Interface" (Figure 1).

   .. figure:: images/uc-if-1.png
      :align: center
      :figwidth: image

      Figure 1: Drop-down menu of the running instance (in Compute -> Instances). The first three options are shown. We will use all three options in this toturial.
 
2. Select the network to detach under "Port". In Figure 2, a dualStack network configuration that is currently used by the running VM instance, is selected for detachment.

   .. figure:: images/uc-if-2.png
      :align: center
      :figwidth: image

      Figure 2: Selecting existing network to detach.
 
3. In the drop-down menu of your running instance, select "Attach Interface" (Figure 1).

4. Select the new (suggested) network to attach. In Figure 3, a new IPv6 network is selected.

   .. figure:: images/uc-if-3.png
      :align: center
      :figwidth: image

      Figure 3: Selecting new network to attach.
 
.. TIP::
   **Automatic removal of security groups**

   Note that all security groups that used the network that you detached were removed
   from the instance as a result of detaching the interface. Because of this, you need to
   re-add the affected security group(s). In the drop-down menu of the running instance (Figure 1), select "Edit Instance". In this toturial, a security group for SSH access
   is re-added as shown in Figure 4.

   .. figure:: images/uc-if-4.png
      :align: center
      :figwidth: image

      Figure 4: Adding security group for SSH access.

Linux VM user management
------------------------

Your Linux VM will come with a root user in addition to a cloud user as described in `Current GOLD images`_.

User management follows standard Linux procedures. Below are some useful commands:

.. list-table:: Table 1: Linux commands for basic user management.
   :widths: 50 25 25
   :header-rows: 1

   * - Command
     - Description
     - Use case
   * - ``openssl rand -base64 6``
     - Generate random 6-digit password
     - Interactive
   * - ``sudo adduser <username>``
     - Create a new user with a password
     - Interactive
   * - ``sudo adduser --disabled-password <username>``
     - Create a new user with disabled password
     - When creating users with key-based login only. The user cannot be authenticated using password
   * - ``sudo useradd -m -s /bin/bash <username>``
     - Create a new user without specifying its password
     - -"-, non-interactive
   * - ``sudo passwd <username>``
     - Set password for user
     - Interactive
   * - ``sudo gpasswd -a <username> <groupname>``
     - Add user <username> to the group <groupname>
     - Ex. adding user admin to group sudo
   * - ``sudo passwd -l <username>``
     - Disable (lock) the password for <username>
     - The user can no longer be authenticated using password. Login to the user with other authentication methods will still work
   * - ``google-authenticator``
     - Run 2FA setup for scanning QR code with OTP mobile app
     - When having set up SSH to use the Google Authenticator PAM

Example:

Creating the additional user student with disabled password. From root:

.. code-block:: console

   adduser --disabled-password student

This should also create the home directory ``/home/student``.

SSH keys

The public SSH key you selected in the in the wizard when creating the VM instance, was installed for the cloud and root user. However, by default, public key-based SSH login is only enabled for the cloud user. If you like to enable this for root (not recommended), you need to edit the correspondig settings in ``/etc/ssh/sshd_config``, followed by a restart of the ssh service.

Example:

The manual process of installing the public SSH key for student is the following (from root):

.. code-block:: console

   mkdir -p /home/student/.ssh
   # Substitute KEY with the public SSH key received from user student
   echo KEY >> /home/student/.ssh/authorized_keys

2FA/MFA

You may want to setup the VM to use a pluggable authentication module (PAM) with your public SSH key `and` mobile one-time-password (OTP) app. Google Authenticator provides such a setup. The installation may vary with Linux distribution. For Debian-based systems, the package to install is ``libpam-google-authenticator`` and configuration is performed in ``/etc/pam.d/sshd`` and ``/etc/ssh/sshd_config``.

Example: Assuming that Google Authenticator PAM is setup correctly with the SSH server in the VM. From root:

.. code-block:: console

   su - student
   google-authenticator

A good default is to say yes ('y') to all options. A QR code should be printed. The student needs to somehow scan this QR code using any mobile OTP app. Additionally, the file ``/home/student/.google_authenticator`` will be created together with the generated QR code. This file can be deleted if you wish to re-run the ``google-authenticator`` command to get a new QR code.

Sudo

Passwordless sudo right is granted to the cloud user. This means that you may want to use sudo to set the root password while logged in with the cloud user, as described in `How do I set the root password for my Linux instance?`_. The config file enabling passwordless sudo for the cloud user should be located in ``/etc/sudoers.d/``. If you want passwordless sudo right for additional users, you can edit this file accordingly.

Example: To grant sudo right to user student, add user student to the group sudo. Then, find and edit the file where the cloud user is granted sudo right. For Ubuntu, the file is ``/etc/sudoers.d/90-cloud-init-users``. From root:

.. code-block:: console

   gpasswd -a student sudo
   echo -e '# User rules for ubuntu\nstudent ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers.d/90-cloud-init-users

If you followed the examples in this toturial, note that student can change to any user in the VM (using sudo su - <username>).

To prevent student from accessing other users, student and any other users in the VM should not have sudo rights, as well as a disabled password.

Any user logged into the VM may change to another user with password enabled (using su - <username>). This is a reason to create users with the --disabled-password option.

Shared account:

A shared user group1 may be created with password, and the password can be shared within the group. All members of the group should then be able to login to the VM using user group1 and shared password simultaneously. Shared accounts may also be accomplished by sharing the full (private+public) SSH key and possibly OTP app. However, this use case would go against introducing these increased security measures in the first place.

Remote Desktop Access
=====================

Lightweight Linux DE - LXDE + XRDP
----------------------------------

This is a tutorial on how you may setup a minimal graphical desktop environment (DE) in your linux VM, and access it remotely using the Remote Desktop Protocol (RDP) over a Secure Shell (SSH) tunnel.

- LXDE: Lightweight X Desktop Environment
- xrdp, a VDI server using the Remote Desktop Protocol (RDP) protocol, and that starts isolated X sessions
- Web browser (firefox)
- File browser (pcmanfm)
- File de-compress/compress tool (xarchiver)
- Text processor (mousepad)
- Terminal emulator (lxterminal)
- Decent theme (shimmer themes).

Abbreviations:

RDP: Remote Desktop Protocol, SSH: Secure Shell, GUI: Graphical User Interface, VDI: Virtual Desktop Infrastructure, DE: Desktop Environment

.. Note::

   The specific steps required for GUI to your linux VM instance depend heavily on the software and distribution. The steps in this toturial are likely to change in the future. The last edit was 2024-09-04.

1. Launch a new linux VM instance

  - Image: GOLD Ubuntu 24.04 LTS
  - Flavor: m1.medium (4 GB RAM, 20 GB OS disk)
  - Network: IPv6
  - Add a security group that allows SSH to the instance for IPv6
  - Add your SSH key

  In this, toturial the instance is named ``vdi``

2. SSH login with TCP tunnel for RDP connection

   .. code-block:: console

      ssh ubuntu@<IPv6 address> -L 45000:localhost:3389

   where we choose a high numbered port that we want to use to access our DE on ``localhost`` on our local machine.

   If you are on a IPv4 only network such as eduroam, you can connect through ``login.uio.no`` or ``login.uib.no``, e.g., for UiO users

   .. code-block:: console

      ssh -J <username>@login.uio.no ubuntu@<IPv6 address> -L 45000:localhost:3389

   where <username> is your UiO username. This requires that your SSH key is installed on the login host.

3. Set password for the cloud user (will be asked with VDI login)

   .. code-block:: console

      sudo passwd ubuntu

4. Install software

   .. code-block:: console
      
      sudo apt update -y && sudo apt install -y xrdp openbox-lxde-session lxappearance lxterminal xarchiver mousepad shimmer-themes firefox

5. First VDI login

   Use a RDP Client to connect to ``localhost:45000``. The client to use on Windows is the built-in Windows Remote Desktop. A good Linux client is Remmina.

   You will be asked to login as user ubuntu with the password you set previously.

5. Necessary fixes

   - Fix lxpanel bug for Ubuntu 24.04 LTS [#f1]_ [#f2]_

     ``Right click on (the visible part of the) panel -> Panel Settings -> Panel Applets, select Desktop Pager, then click Remove``

   - Set decent theme

     ``Preferences -> Customize Look and Feel, select Greybird-dark -> Apply -> Close``

     ``Preferences -> Openbox Configuration Manager, select Numix -> Close``

     ``Right click on panel -> Panel Settings -> Appearance, under Background, select System theme -> Close``

   - Disable screensaver to avoid unwanted CPU consumption

     ``Preferences -> XScreenSaver Settings -> Mode: Disable Screen Saver -> Close``

   - (Windows only) Fix Windows Remote Desktop specific issues [#f3]_

     Enable shared clipboard as well as drive redirection in Windows Remote Desktop client (to ``thinclient_drives`` mount): Make sure Windows Remote Desktop client is configured properly by unchecking Printers and Smart cards. Select the drive(s) to redirect, as well as Clipboard, then save the profile.

6. Finish

   This toturial used the Remmina RDP client with custom screen resolution set to 1920x1080 (Figure 5).

   .. figure:: images/uc-vdi-1.png
      :align: center
      :figwidth: image

      Figure 5: Screenshot of the virtual DE with the GUI tools installed in this toturial.
 
.. rubric:: Footnotes

.. [#f1] https://askubuntu.com/questions/1518705/lxde-panel-gets-cut-off-on-ubuntu-24-04
   
.. [#f2] https://sourceforge.net/p/lxde/bugs/968/

.. [#f3] https://github.com/neutrinolabs/xrdp/issues/308

Remote Desktop - GNOME + XRDP (Terraform)
-----------------------------------------
This tutorial demonstrates how to deploy a ready-to-use Ubuntu 24.04 LTS VM with a GNOME desktop and XRDP remote access on NREC OpenStack, using the one-click deployment scripts from the `nrec-oneclick-vps <https://github.com/norcams/nrec-oneclick-vps/>`_ repository.

The steps are similar to the `Remote Desktop - GNOME + TurboVNC (Terraform)`_ tutorial. The main difference is that this tutorial uses the main branch of the repository (GNOME + XRDP) instead of the ``turbovnc`` branch (GNOME + TurboVNC).

.. TIP::
   **Prerequisites**

   - Terraform >= 1.5
   - NREC OpenStack credentials (``OS_USERNAME``, ``OS_PASSWORD``, ``OS_PROJECT_NAME``, ``OS_REGION_NAME``)
   - SSH client
   - RDP viewer (built-in on Windows, Remmina on Linux)
   - Git (to clone the repository)

1. Clone the repository

   .. code-block:: console

      git clone https://github.com/norcams/nrec-oneclick-vps.git
      cd nrec-oneclick-vps

2. Create and fill in the environment file

   .. code-block:: console

      cp env.sh.template env.sh

   Edit ``env.sh`` and set your OpenStack API credentials:

   - ``OS_USERNAME``: your username (e.g. ``user@institution.no``)
   - ``OS_PASSWORD``: your password
   - ``OS_PROJECT_NAME``: your project name
   - ``OS_REGION_NAME``: your region (e.g. ``bgo``)

   The ``OS_AUTH_URL`` is pre-set to ``https://identity.api.bgo.nrec.no:5000/v3``.

3. Deploy the VM

   .. code-block:: console

      ./deploy.sh

   The script will:

   - Auto-detect your public IPv4/IPv6 address
   - Generate a ``terraform.tfvars`` with default flavor (``c1.xlarge``) and image (``GOLD Ubuntu 24.04 LTS``). These can be changed directly in ``deploy.sh``.
   - Generate a TLS private key and save it to ``keys/vps-<deployment-id>.pem``
   - Create an OpenStack keypair
   - Create a security group with SSH-only ingress
   - Launch a VM with cloud-init (installs XRDP, GNOME desktop, Google Chrome)
   - Print the VM IP addresses and SSH command

   Credentials are saved to:

   - On VM: ``cat /home/ubuntu/.admin-password`` (for XRDP login)

4. SSH login with RDP connection

   .. code-block:: console

      ssh ubuntu@<IPv6 address> -L 45000:localhost:3389

   where we choose a high numbered port that we want to use to access our DE on ``localhost`` on our local machine.

   If you are on a IPv4 only network such as eduroam, you can connect through ``login.uio.no`` or ``login.uib.no``, e.g., for UiO users

   .. code-block:: console

      ssh -J <username>@login.uio.no ubuntu@<IPv6 address> -L 45000:localhost:3389

   where <username> is your UiO username. This requires that your SSH key is installed on the login host.

5. First RDP login

   Use an RDP Client to connect to ``localhost:45000``. The client to use on Windows is the built-in Windows Remote Desktop. A good Linux client is Remmina.

   You will be asked to login as user ubuntu with the password from ``/home/ubuntu/.admin-password``.

6. Tear down the VM

   When finished, destroy all provisioned resources (including the VM, security groups, keypair, and local key files):


   .. code-block:: console

      terraform destroy

Remote Desktop - GNOME + TurboVNC (Terraform)
---------------------------------------------

This tutorial demonstrates how to deploy a ready-to-use Ubuntu 24.04 LTS VM with a GNOME desktop and TurboVNC remote access on NREC OpenStack, using the one-click deployment scripts from the `nrec-oneclick-vps <https://github.com/norcams/nrec-oneclick-vps/>`_ repository.

.. TIP::
   **Prerequisites**

   - Terraform >= 1.5
   - NREC OpenStack credentials (``OS_USERNAME``, ``OS_PASSWORD``, ``OS_PROJECT_NAME``, ``OS_REGION_NAME``)
   - SSH client
   - TurboVNC viewer
   - Git (to clone the repository)

1. Clone the repository

   .. code-block:: console

      git clone https://github.com/norcams/nrec-oneclick-vps.git
      cd nrec-oneclick-vps
      git checkout turbovnc

2. Create and fill in the environment file

   .. code-block:: console

      cp env.sh.template env.sh

   Edit ``env.sh`` and set your OpenStack API credentials:

   - ``OS_USERNAME``: your username (e.g. ``user@institution.no``)
   - ``OS_PASSWORD``: your password
   - ``OS_PROJECT_NAME``: your project name
   - ``OS_REGION_NAME``: your region (e.g. ``bgo``)

   The ``OS_AUTH_URL`` is pre-set to ``https://identity.api.bgo.nrec.no:5000/v3``.

.. TIP::
   **Windows**

   Windows users: copy ``env.ps1.template`` to ``env.ps1`` and set the same OpenStack credentials there. Run ``deploy.ps1`` instead of ``deploy.sh``.

3. Deploy the VM

   .. code-block:: console

      ./deploy.sh

   The script will:

   - Auto-detect your public IPv4/IPv6 address
   - Generate a ``terraform.tfvars`` with default flavor (``c1.xlarge``) and image (``GOLD Ubuntu 24.04 LTS``). These can be changed directly in ``deploy.sh``.
   - Generate a TLS private key and save it to ``keys/vps-<deployment-id>.pem``
   - Create an OpenStack keypair
   - Create a security group with SSH-only ingress
   - Launch a VM with cloud-init (installs TurboVNC, GNOME desktop, Google Chrome)
   - Print the VM IP addresses and SSH command

   Credentials are saved to:

   - VNC password: ``keys/vps-<deployment-id>.vncpass``
   - On VM: ``cat /home/ubuntu/.vnc-passwd``

4. SSH login with VNC tunnel

   .. code-block:: console

      ssh -L 55901:localhost:5901 -i keys/vps-<deployment-id>.pem ubuntu@<VM_IP>

   If you are connecting from IPv6-only:

   .. code-block:: console

      ssh -L 55901:localhost:5901 -i keys/vps-<deployment-id>.pem ubuntu@<VM_IPv6>

5. Start a VNC session and connect

   .. code-block:: console

      vncserver :1

   Then connect with TurboVNC to ``localhost:55901``, using the password from ``/home/ubuntu/.vnc-passwd``.

   .. TIP::
      **Desktop session**

      The default session starts with GNOME Flashback (Metacity). For the full modern GNOME session:

      .. code-block:: console

         vncserver :1 -wm gnome

6. Tear down the VM

   When finished, destroy all provisioned resources (including the VM, security groups, keypair, and local key files):

   .. code-block:: console

      terraform destroy

Local AI Inference
==================

Qwen3.6 on L40S for agentic tasks
---------------------------------

This tutorial demonstrates how to run the `Qwen3.6-35B-A3B <https://unsloth.ai/docs/models/qwen3.6#mtp-qwen3.6-35b-a3b>`_ LLM with decent inference speed on an NREC L40s instance using llama.cpp and multi-token prediction (MTP).

.. TIP::
   **Instance requirements**

   - Flavor: ``gr1.L40S.24g.4xlarge`` (24 GB NVIDIA L40S vGPU)
   - Image: vGPU Ubuntu 24.04 LTS
   - Model: `unsloth/Qwen3.6-35B-A3B-MTP-GGUF <https://huggingface.co/unsloth/Qwen3.6-35B-A3B-MTP-GGUF>`_ with UD-Q2_K_XL dynamic 2-bit quantization

   The UD-Q2_K_XL quantization is a dynamic 2-bit format from Unsloth that reduces memory usage and increases inference speed. The A3B suffix indicates a Mixture of Experts (MoE) variant; no equivalent MoE variant exists yet for Qwen3.8.

1. Create and prepare the instance

   Create a new instance with the flavor and image above. After login, install required packages:

   .. code-block:: console

      sudo apt update
      sudo apt install -y nvidia-cuda-toolkit git python3-venv python3-pip pciutils build-essential cmake curl libcurl4-openssl-dev nvtop nload

      sudo timedatectl set-timezone Europe/Oslo

   Follow the "Upgrading the instance drivers" section from the `NREC vGPU documentation <https://docs.nrec.no/vgpu.html#upgrading-the-instance-drivers>`_ to install the latest NVIDIA drivers.

2. Verify GPU

   .. code-block:: console

      nvidia-smi

   You should see the NVIDIA L40S GPU listed.

3. Build llama.cpp

   .. code-block:: console

      git clone https://github.com/ggml-org/llama.cpp
      cd llama.cpp
      cmake -B build -DBUILD_SHARED_LIBS=OFF -DGGML_CUDA=ON
      cmake --build build --config Release -j --clean-first --target llama-cli llama-mtmd-cli llama-server llama-gguf-split
      cp build/bin/llama-* .

4. Create a Python environment and download the model

   .. code-block:: console

      cd /home/ubuntu/llama.cpp
      python3 -m venv hf-llama
      source hf-llama/bin/activate
      pip install -U "huggingface_hub"

   .. code-block:: console

      hf download unsloth/Qwen3.6-35B-A3B-MTP-GGUF \
          --local-dir unsloth/Qwen3.6-35B-A3B-MTP-GGUF \
          --include "*mmproj-F16*" \
          --include "*UD-Q2_K_XL*"

5. Start the inference server

   .. code-block:: console

      ./llama-server \
          --model unsloth/Qwen3.6-35B-A3B-MTP-GGUF/Qwen3.6-35B-A3B-UD-Q2_K_XL.gguf \
          --mmproj unsloth/Qwen3.6-35B-A3B-MTP-GGUF/mmproj-F16.gguf \
          --temp 0.6 --top-p 0.95 --min-p 0.00 --top-k 20 \
          --ctx-size 262144 --port 8001 \
          --spec-type draft-mtp --spec-draft-n-max 2 \
          --chat-template-kwargs '{"preserve_thinking":true}' \
          --no-mmap --image-min-tokens 1024

   Key options explained:

   - ``--spec-type draft-mtp --spec-draft-n-max 2``: enables multi-token prediction, a speculative decoding technique that speeds up inference significantly
   - ``--mmproj``: enables image recognition capability (the multimodal projector); agentic frameworks with built-in image tools such as Hermes desktop should auto-detect and use it
   - ``--chat-template-kwargs '{"preserve_thinking":true}'``: adds extra reasoning tokens that improve the model's reasoning quality
   - ``--no-mmap``: avoids memory mapping for better GPU performance
   - ``--image-min-tokens 1024``: minimum tokens allocated for image processing

   The server exposes an OpenAI-compatible API at ``http://127.0.0.1:8001/v1``.

   To use the CLI instead of the server, run ``llama-cli`` with the same arguments (omit ``--port``).

   .. NOTE::
      The ``--spec-type draft-mtp --spec-draft-n-max 2`` flags cause a CUDA kernel
      crash with very short inputs (1-2 characters) in ``llama-cli``. These flags are
      safe to use with ``llama-server`` (which handles longer context), but should be
      omitted when running ``llama-cli`` interactively.

6. Connect an agentic framework

   Configure your agentic framework (e.g., agentic frameworks with built-in image tools such as Hermes desktop) to use the local endpoint:

   .. code-block:: console

      # In your agent config:
      # provider: custom
      # endpoint: http://127.0.0.1:8001/v1

   Stop the server with ``Ctrl+C``.

Qwen3.6 on L40S for agentic tasks (Ubuntu 26.04 LTS)
-----------------------------------------------------

This is an adaptation of the `Qwen3.6 on L40S for agentic tasks`_ tutorial for Ubuntu 26.04 LTS (Resolute Raccoon).

.. TIP::
   **Instance requirements**

   - Flavor: ``gr1.L40S.24g.4xlarge`` (24 GB NVIDIA L40S vGPU)
   - Image: ``vGPU Ubuntu 26.04 LTS``
   - Model: `unsloth/Qwen3.6-35B-A3B-MTP-GGUF <https://huggingface.co/unsloth/Qwen3.6-35B-A3B-MTP-GGUF>`_ with UD-Q2_K_XL dynamic 2-bit quantization

   The UD-Q2_K_XL quantization is a dynamic 2-bit format from Unsloth that reduces memory usage and increases inference speed. The A3B suffix indicates a Mixture of Experts (MoE) variant; no equivalent MoE variant exists yet for Qwen3.8.

1. Create and prepare the instance

   Create a new instance with the flavor and image above. After login, install
   required packages:

   .. code-block:: console

      sudo apt update
      sudo apt install -y cuda-toolkit-13 gcc-14 g++-14 git cmake nvtop btop tree nvitop nload python3.14-venv

      sudo timedatectl set-timezone Europe/Oslo

   .. NOTE::
      **Two pre-built fixes are required on Ubuntu 26.04 LTS.**

      **NVML version mismatch:** The vGPU image ships with kernel module ``580.159.03``,
      but ``cuda-toolkit-13`` installs userspace ``580.173.02``. This breaks ``nvidia-smi``.
      Fix by re-linking the NVML symlink:

      .. code-block:: console

         sudo ln -sf libnvidia-ml.so.580.159.03 /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.1

      Substitute the actual kernel module version with
      ``ls /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.580.* | head -1`` to find the correct version.

      **CUDA/GCC incompatibility:** CUDA 13.1 does not support GCC 15 (the default on
      Ubuntu 26.04 LTS). nvcc reads GCC 15's ``bits/mathcalls.h`` which conflicts with
      CUDA 13.1's ``math_functions.h`` (``noexcept(true)`` vs no ``noexcept``).
      Patch before building:

      .. code-block:: console

         MATH_F=/usr/local/cuda/targets/x86_64-linux/include/crt/math_functions.h
         sudo sed -i 's/extern __DEVICE_FUNCTIONS_DECL__ __device_builtin__ double                 rsqrt(double x);/extern __DEVICE_FUNCTIONS_DECL__ __device_builtin__ double                 rsqrt(double x) noexcept(true);/' $MATH_F
         sudo sed -i 's/extern __DEVICE_FUNCTIONS_DECL__ __device_builtin__ float                  rsqrtf(float x);/extern __DEVICE_FUNCTIONS_DECL__ __device_builtin__ float                  rsqrtf(float x) noexcept(true);/' $MATH_F

      These cmake flags alone cannot fix these issues — both fixes are mandatory.

2. Verify GPU

   .. code-block:: console

      nvidia-smi

   You should see the NVIDIA L40S GPU listed.

3. Build llama.cpp

   .. code-block:: console

      git clone https://github.com/ggml-org/llama.cpp
      cd llama.cpp
      export PATH=/usr/local/cuda/bin:\$PATH
      cmake -B build \
        -DBUILD_SHARED_LIBS=OFF \
        -DGGML_CUDA=ON \
        -DCMAKE_CUDA_HOST_COMPILER=g++-14 \
        -DCMAKE_CXX_COMPILER=g++-14 \
        -DCMAKE_CUDA_COMPILER=/usr/local/cuda/bin/nvcc \
        -DCMAKE_CUDA_ARCHITECTURES=86
      cmake --build build --config Release -j
      cp build/bin/llama-* .

   Key build flags:

   - ``-DCMAKE_CUDA_HOST_COMPILER=g++-14``: tells nvcc to use GCC 14 (required because CUDA 13.1 does not support GCC 15)
   - ``-DCMAKE_CUDA_ARCHITECTURES=86``: targets sm_86 (L40S Ampere compute capability)

4. Create a Python environment and download the model

   .. code-block:: console

      python3 -m venv hf-llama
      source hf-llama/bin/activate
      pip install -U "huggingface_hub"

   .. code-block:: console

      hf download unsloth/Qwen3.6-35B-A3B-MTP-GGUF \
          --local-dir unsloth/Qwen3.6-35B-A3B-MTP-GGUF \
          --include "*mmproj-F16*" \
          --include "*UD-Q2_K_XL*"

5. Start the inference server

   .. code-block:: console

      ./llama-server \
          --model unsloth/Qwen3.6-35B-A3B-MTP-GGUF/Qwen3.6-35B-A3B-UD-Q2_K_XL.gguf \
          --mmproj unsloth/Qwen3.6-35B-A3B-MTP-GGUF/mmproj-F16.gguf \
          --temp 0.6 --top-p 0.95 --min-p 0.00 --top-k 20 \
          --ctx-size 262144 --port 8001 \
          --spec-type draft-mtp --spec-draft-n-max 2 \
          --chat-template-kwargs '{"preserve_thinking":true}' \
          --load-mode mmap --image-min-tokens 1024

   Key options explained:

   - ``--spec-type draft-mtp --spec-draft-n-max 2``: enables multi-token prediction, a speculative decoding technique that speeds up inference significantly
   - ``--mmproj``: enables image recognition capability (the multimodal projector); agentic frameworks with built-in image tools such as Hermes desktop should auto-detect and use it
   - ``--chat-template-kwargs '{"preserve_thinking":true}'``: adds extra reasoning tokens that improve the model's reasoning quality
   - ``--load-mode mmap``: memory-mapped model loading (replaces the deprecated ``--no-mmap``)
   - ``--image-min-tokens 1024``: minimum tokens allocated for image processing

   The server exposes an OpenAI-compatible API at ``http://127.0.0.1:8001/v1``.

   To use the CLI instead of the server, run ``llama-cli`` with the same arguments (omit ``--port``).

   .. NOTE::
      The ``--spec-type draft-mtp --spec-draft-n-max 2`` flags cause a CUDA kernel
      crash with very short inputs (1-2 characters) in ``llama-cli``. These flags are
      safe to use with ``llama-server`` (which handles longer context), but should be
      omitted when running ``llama-cli`` interactively.

   Benchmarks measured on the L40S:

   - Model load time: ~4.6s
   - Prompt eval: ~10.2ms/token (98 t/s)
   - MTP generation: ~5.0ms/token (200 t/s), 100% draft acceptance, 12 drafts accepted

6. Connect an agentic framework

   Configure your agentic framework (e.g., agentic frameworks with built-in image tools such as Hermes desktop) to use the local endpoint:

   .. code-block:: console

      # In your agent config:
      # provider: custom
      # endpoint: http://127.0.0.1:8001/v1

   Stop the server with ``Ctrl+C``.

OnDemand Qwen3.8 on Fox (llama.cpp, SSH tunnel access)
-------------------------------------------------------

This tutorial demonstrates how to run Qwen3.8-27B with usable inference speed on the Fox HPC cluster (Educloud) using llama.cpp and a Slurm GPU job. Fox provides short-duration GPU resources (A100 80GB) that can be used to run LLM inference on demand. Run the inference server interactively with ``salloc`` or submit a batch job with ``sbatch``, then connect to it from your existing agent framework running locally on your machine or in a NREC instance via SSH tunnel.

.. NOTE::

   These jobs require access to the UiO HPC system (called Fox) through Educloud. You must have an active project account (e.g. ``ecXXX``) with GPU quota in the ``accel`` partition.

.. TIP::

   **Data classification**

   For this usecase NREC and Educloud are classified for data up to the **yellow** category. See the `UiO data classification guide <https://www.uio.no/english/services/it/security/lsis/data-classes.html>`_ for details.

.. TIP::

   **Backend choice**

   vLLM installs from precompiled pip wheels (no build step), while llama.cpp requires compilation from source. Compiling llama.cpp against the specific GPU architecture (sm_80 for A100) may yield better performance. Additionally, llama.cpp includes ``llama-cli`` for interactive testing before connecting from your agent framework.

.. TIP::

   **Prerequisites**

   - Fox Educloud account (e.g. ``ec-[username]@fox.educloud.no``)
   - SSH client with port forwarding support (only for batch jobs)

1. Find available partitions and GPU resources

Before submitting jobs, check what partitions and GPU types are available:

.. code-block:: console

   $ sinfo -p accel
   $ scontrol show partition accel
   $ projects

2. Select a model

   Two verified Qwen3.8-27B models are available for llama.cpp on A100 80GB and A40 48GB. Choose one before proceeding.

   .. table::
      :widths: auto

      +-----------------------------+--------------------------------------------+
      | **zerodigest YMQ-M**        | **HauhauCS Aggressive Q4_K_P**             |
      +=============================+============================================+
      | `zerodigest/Qwen3.8-27B-    | `HauhauCS/Qwen3.8-27B-Uncensored-HauhauCS- |
      | Uncensored-YMQ-MTP-GGUF`    | Aggressive-MTP-GGUF`                       |
      +-----------------------------+--------------------------------------------+
      | Quantization: YMQ-M (~14 GB)| Quantization: Q4_K_P (~19 GB) + FastMTP    |
      |                             | sidecar (903 MB)                           |
      +-----------------------------+--------------------------------------------+
      | ~50-65 tok/s with           | ~50-65 tok/s with                          |
      | ``--spec-type draft-mtp     | ``--spec-draft-model`` + ``--spec-draft-ngl|
      | --spec-draft-n-max 2``      | all --spec-type draft-mtp --spec-draft-    |
      |                             | n-max 3 --spec-draft-p-min 0``             |
      +-----------------------------+--------------------------------------------+
      | No patch required           | Requires FastMTP patch before build        |
      +-----------------------------+--------------------------------------------+
      | Standard MTP speculative    | Up to 3.02x document throughput vs MTP     |
      | decoding                    | disabled                                   |
      +-----------------------------+--------------------------------------------+

3. Interactive mode (salloc)

   Allocate an A100 80GB or A40 48GB GPU interactively and run ``llama-cli`` directly. First, SSH to the login node, then request an interactive GPU session:

   .. code-block:: console

      ssh -l ec-[username] fox.educloud.no
      # Run salloc from the login node to get an interactive shell on a compute node
      salloc --partition=accel --gpus=a100_80:1 --ntasks=1 --cpus-per-task=32 --mem-per-cpu=4G --time=00:30:00 --qos=devel --account=ecXXX

      .. NOTE::

         The high ``--cpus-per-task=32`` value speeds up compilation. For inference-only runs, it can be reduced to 8 without affecting throughput. A lower value also tends to allocate resources faster (less waiting time).
      module purge
      module load CUDA/12.8.0 CMake/4.0.3-GCCcore-14.3.0
      mkdir -p ~/llm-inference && cd ~/llm-inference

      # Install huggingface_hub for model download (cached after first run)
      if [ ! -d "hf-venv" ]; then
         python3 -m venv hf-venv
         source hf-venv/bin/activate
         pip install -U "huggingface_hub"
      else
         source hf-venv/bin/activate
      fi

      # Clone and build llama.cpp (cached after first run)
      if [ ! -d "llama.cpp" ]; then
         git clone https://github.com/ggml-org/llama.cpp
         cd llama.cpp
         cmake -B build -DBUILD_SHARED_LIBS=OFF -DGGML_CUDA=ON -DCMAKE_CUDA_ARCHITECTURES=80
         cmake --build build --config Release -j 32 --target llama-server llama-cli
         cp build/bin/llama-* .
         cd ..
      fi

      # HauhauCS only: apply FastMTP patch and rebuild
      if [ -d "models/HauhauCS" ] && [ ! -d "models/zerodigest" ]; then
         cd llama.cpp
         git checkout 4df29be4f4c3673f428170fda944a5b19f743bb8
         curl -L -o HauhauCS-FastMTP-llama.cpp.patch https://huggingface.co/HauhauCS/Qwen3.8-27B-Uncensored-HauhauCS-Aggressive-MTP-GGUF/resolve/main/HauhauCS-FastMTP-llama.cpp.patch
         git apply --check HauhauCS-FastMTP-llama.cpp.patch
         git apply HauhauCS-FastMTP-llama.cpp.patch
         cmake --build build --config Release -j 32 --target llama-server llama-cli
         cp build/bin/llama-* .
         cd ..
      fi

**Choice 1: zerodigest YMQ-M (~14 GB)**

   .. code-block:: console

      # Download model + mmproj (cached after first run)
      if [ ! -d "models/zerodigest/Qwen3.8-27B-Uncensored-YMQ-MTP-GGUF" ]; then
         mkdir -p models/zerodigest/Qwen3.8-27B-Uncensored-YMQ-MTP-GGUF
         HF_HUB_DISABLE_XET=1 python3 -c "from huggingface_hub import hf_hub_download; hf_hub_download(repo_id='zerodigest/Qwen3.8-27B-Uncensored-YMQ-MTP-GGUF', filename='Qwen3.8-27B-Uncensored-YMQ-M.gguf', local_dir='models/zerodigest/Qwen3.8-27B-Uncensored-YMQ-MTP-GGUF'); hf_hub_download(repo_id='zerodigest/Qwen3.8-27B-Uncensored-YMQ-MTP-GGUF', filename='mmproj/Qwen3.8-27B-Uncensored-vision-Q8_0.gguf', local_dir='models/zerodigest/Qwen3.8-27B-Uncensored-YMQ-MTP-GGUF/mmproj')"
      fi

      # Start interactive chat
      ./llama.cpp/llama-cli --model models/zerodigest/Qwen3.8-27B-Uncensored-YMQ-MTP-GGUF/Qwen3.8-27B-Uncensored-YMQ-M.gguf --mmproj models/zerodigest/Qwen3.8-27B-Uncensored-YMQ-MTP-GGUF/mmproj/mmproj/Qwen3.8-27B-Uncensored-vision-Q8_0.gguf --ctx-size 262144 --chat-template-kwargs '{"preserve_thinking":true}' --flash-attn on --batch-size 2048 --ubatch-size 1024 --cache-type-k q8_0 --cache-type-v q8_0 --spec-type draft-mtp --spec-draft-n-max 2

   **Verified throughput**: ~50-65 tok/s on A100 80GB with ``--spec-type draft-mtp --spec-draft-n-max 2`` (1.3-1.5x speedup over baseline).

**Choice 2: HauhauCS Aggressive Q4_K_P (~19 GB) + FastMTP sidecar (903 MB)**

   .. code-block:: console

      # Download model + mmproj + FastMTP sidecar (cached after first run)
      if [ ! -d "models/HauhauCS" ]; then
         mkdir -p models/HauhauCS
         HF_HUB_DISABLE_XET=1 python3 -c "from huggingface_hub import snapshot_download; snapshot_download(repo_id='HauhauCS/Qwen3.8-27B-Uncensored-HauhauCS-Aggressive-MTP-GGUF', allow_patterns=['*Q4_K_P*', '*mmproj*', '*FastMTP*'], local_dir='models/HauhauCS')"
      fi

      # Start interactive chat
      ./llama.cpp/llama-cli --model models/HauhauCS/Qwen3.8-27B-Uncensored-HauhauCS-Aggressive-Q4_K_P.gguf --mmproj models/HauhauCS/mmproj-Qwen3.8-27B-Uncensored-HauhauCS-Aggressive-BF16.gguf --spec-draft-model models/HauhauCS/Qwen3.8-27B-Uncensored-HauhauCS-Aggressive-FastMTP-32K.gguf --spec-draft-ngl all --spec-type draft-mtp --spec-draft-n-max 3 --spec-draft-p-min 0 --ctx-size 262144 --parallel 1 --batch-size 2048 --ubatch-size 512 --n-gpu-layers all --split-mode none --flash-attn on --no-mmap --temp 1.0 --top-k 20 --top-p 0.95 --min-p 0 --presence-penalty 0 --repeat-penalty 1.0 --jinja --reasoning on --reasoning-effort xhigh --reasoning-preserve --reasoning-format deepseek

   **Verified throughput**: ~50-65 tok/s on A100 80GB with FastMTP sidecar (up to 3.02x document throughput vs MTP disabled).

4. Batch mode (sbatch)

   .. code-block:: console

      cat > qwen38-llamacpp-job.sh << 'EOF'
      #!/bin/bash
      #SBATCH --job-name=qwen38-llamacpp
      #SBATCH --partition=accel
      #SBATCH --account=ecXXX
      #SBATCH --gpus=a100_80:1
      #SBATCH --ntasks-per-node=1
      #SBATCH --cpus-per-task=32
      #SBATCH --mem-per-cpu=4G
      #SBATCH --time=00:30:00
      #SBATCH --output=slurm-%j.out
      #SBATCH --error=slurm-%j.err

      module purge
      module load CUDA/12.8.0 CMake/4.0.3-GCCcore-14.3.0

      WORKDIR=$HOME/llm-inference
      mkdir -p $WORKDIR
      cd $WORKDIR

      # Install huggingface_hub for model download (cached after first run)
      if [ ! -d "hf-venv" ]; then
         python3 -m venv hf-venv
         source hf-venv/bin/activate
         pip install -U "huggingface_hub"
      else
         source hf-venv/bin/activate
      fi

      # Clone and build llama.cpp (cached after first run)
      if [ ! -d "llama.cpp" ]; then
         git clone https://github.com/ggml-org/llama.cpp
         cd llama.cpp
         cmake -B build -DBUILD_SHARED_LIBS=OFF -DGGML_CUDA=ON -DCMAKE_CUDA_ARCHITECTURES=80
         cmake --build build --config Release -j 32 --target llama-server llama-cli
         cp build/bin/llama-* .
         cd ..
      fi

      # HauhauCS only: apply FastMTP patch and rebuild
      if [ -d "models/HauhauCS" ] && [ ! -d "models/zerodigest" ]; then
         cd llama.cpp
         git checkout 4df29be4f4c3673f428170fda944a5b19f743bb8
         curl -L -o HauhauCS-FastMTP-llama.cpp.patch https://huggingface.co/HauhauCS/Qwen3.8-27B-Uncensored-HauhauCS-Aggressive-MTP-GGUF/resolve/main/HauhauCS-FastMTP-llama.cpp.patch
         git apply --check HauhauCS-FastMTP-llama.cpp.patch
         git apply HauhauCS-FastMTP-llama.cpp.patch
         cmake --build build --config Release -j 32 --target llama-server llama-cli
         cp build/bin/llama-* .
         cd ..
      fi

**Choice 1: zerodigest YMQ-M**

   .. code-block:: console

      # Download model + mmproj (cached after first run)
      if [ ! -d "models/zerodigest/Qwen3.8-27B-Uncensored-YMQ-MTP-GGUF" ]; then
         mkdir -p models/zerodigest/Qwen3.8-27B-Uncensored-YMQ-MTP-GGUF
         HF_HUB_DISABLE_XET=1 python3 -c "from huggingface_hub import hf_hub_download; hf_hub_download(repo_id='zerodigest/Qwen3.8-27B-Uncensored-YMQ-MTP-GGUF', filename='Qwen3.8-27B-Uncensored-YMQ-M.gguf', local_dir='models/zerodigest/Qwen3.8-27B-Uncensored-YMQ-MTP-GGUF'); hf_hub_download(repo_id='zerodigest/Qwen3.8-27B-Uncensored-YMQ-MTP-GGUF', filename='mmproj/Qwen3.8-27B-Uncensored-vision-Q8_0.gguf', local_dir='models/zerodigest/Qwen3.8-27B-Uncensored-YMQ-MTP-GGUF/mmproj')"
      fi

      # Start the inference server
      ./llama.cpp/llama-server --model models/zerodigest/Qwen3.8-27B-Uncensored-YMQ-MTP-GGUF/Qwen3.8-27B-Uncensored-YMQ-M.gguf --mmproj models/zerodigest/Qwen3.8-27B-Uncensored-YMQ-MTP-GGUF/mmproj/Qwen3.8-27B-Uncensored-vision-Q8_0.gguf --ctx-size 262144 --port 55000 --chat-template-kwargs '{"preserve_thinking":true}' --flash-attn on --batch-size 2048 --ubatch-size 1024 --cache-type-k q8_0 --cache-type-v q8_0 --spec-type draft-mtp --spec-draft-n-max 2 --host 0.0.0.0
      echo "Server running on port 55000"

**Choice 2: HauhauCS Aggressive Q4_K_P**

   .. code-block:: console

      # Download model + mmproj + FastMTP sidecar (cached after first run)
      if [ ! -d "models/HauhauCS" ]; then
         mkdir -p models/HauhauCS
         HF_HUB_DISABLE_XET=1 python3 -c "from huggingface_hub import snapshot_download; snapshot_download(repo_id='HauhauCS/Qwen3.8-27B-Uncensored-HauhauCS-Aggressive-MTP-GGUF', allow_patterns=['*Q4_K_P*', '*mmproj*', '*FastMTP*'], local_dir='models/HauhauCS')"
      fi

      # Start the inference server
      ./llama.cpp/llama-server --model models/HauhauCS/Qwen3.8-27B-Uncensored-HauhauCS-Aggressive-Q4_K_P.gguf --mmproj models/HauhauCS/mmproj-Qwen3.8-27B-Uncensored-HauhauCS-Aggressive-BF16.gguf --spec-draft-model models/HauhauCS/Qwen3.8-27B-Uncensored-HauhauCS-Aggressive-FastMTP-32K.gguf --spec-draft-ngl all --spec-type draft-mtp --spec-draft-n-max 3 --spec-draft-p-min 0 --ctx-size 262144 --parallel 1 --batch-size 2048 --ubatch-size 512 --n-gpu-layers all --split-mode none --flash-attn on --no-mmap --temp 1.0 --top-k 20 --top-p 0.95 --min-p 0 --presence-penalty 0 --repeat-penalty 1.0 --jinja --reasoning on --reasoning-effort xhigh --reasoning-preserve --reasoning-format deepseek --host 0.0.0.0 --port 55000
      echo "Server running on port 55000"

      EOF
      chmod +x qwen38-llamacpp-job.sh
      sbatch qwen38-llamacpp-job.sh

5. Monitor the job

   .. code-block:: console

      squeue -u ec-[username]
      sstat -j <job-id>

6. Connect an agent framework to the inference server

   First, find the GPU node your job is running on (e.g. ``gpu-17``):

   .. code-block:: console

      squeue -u ec-[username]
      sstat -j <job-id>

   Create an SSH tunnel from your local machine or NREC instance to the GPU node. An SSH tunnel is always required when connecting from your agent framework:

   .. code-block:: console

      ssh -N -l ec-[username] fox.educloud.no -L 50000:[gpu-node]:55000

   .. NOTE::

      The server port (``55000``) may be in use by another user following this tutorial. Change it to an available port (e.g. ``56000``) in both the server startup command and the SSH tunnel.

   Configure your agent framework to use the local endpoint:

   .. code-block:: console

      # In your agent config:
      # provider: custom
      # endpoint: http://127.0.0.1:50000/v1

   .. WARNING::

      The inference server listens on ``0.0.0.0``, exposing it to all users with network access to the GPU node. Always use an SSH tunnel when connecting — do not expose the server directly.

   Test with curl (stream mode):

   .. code-block:: console

      curl -N http://127.0.0.1:50000/v1/chat/completions -H "Content-Type: application/json" -d '{"model":"qwen3.8-27b","messages":[{"role":"user","content":"Hello"}],"max_tokens":50,"stream":true}'

7. Stop the job

   When finished, stop the Slurm job:

   .. code-block:: console

      scancel <job-id>

   Or press ``Ctrl+C`` if the job is running interactively.

.. NOTE::

   Jobs are automatically terminated when the ``--time`` limit expires (``00:30:00`` by default). Save your work accordingly.

OnDemand Qwen3.8 on Fox (vLLM, SSH tunnel access) ⚠️ Unverified draft
-----------------------------------------------------------------------

.. WARNING::

   This tutorial is unverified. The vLLM backend for Qwen3.8-27B on Fox has not yet been tested.
   Performance estimates (~60-80 tok/s) are preliminary and subject to change. Use with caution.

This tutorial demonstrates how to run Qwen3.8-27B with usable inference speed on the Fox HPC cluster (Educloud) using vLLM and a Slurm GPU job. Fox provides short-duration GPU resources (A100 80GB) that can be used to run LLM inference on demand. Run the inference server interactively with ``salloc`` or submit a batch job with ``sbatch``, then connect to it from your existing agent framework running locally on your machine or in a NREC instance via SSH tunnel.

.. NOTE::

   These jobs require access to the UiO HPC system (called Fox) through Educloud. You must have an active project account (e.g. ``ecXXX``) with GPU quota in the ``accel`` partition.

.. TIP::

   **Data classification**

   For this usecase NREC and Educloud are classified for data up to the **yellow** category. See the `UiO data classification guide <https://www.uio.no/english/services/it/security/lsis/data-classes.html>`_ for details.

.. TIP::

   **Backend choice**

   vLLM installs from precompiled pip wheels (no build step), while llama.cpp requires compilation from source. Compiling llama.cpp against the specific GPU architecture (sm_80 for A100) may yield better performance. Additionally, llama.cpp includes ``llama-cli`` for interactive testing before connecting from your agent framework.

.. TIP::

   **Prerequisites**

   - Fox Educloud account (e.g. ``ec-[username]@fox.educloud.no``)
   - SSH client with port forwarding support (only for batch jobs)
   - Python 3.10+ environment
   - vLLM >= 0.27.0


1. Interactive mode (salloc)

   Allocate an A100 80GB or A40 48GB GPU interactively, start the vLLM server, and chat via curl. First, SSH to the login node, then request an interactive GPU session:

   .. code-block:: console

      ssh -l ec-[username] fox.educloud.no
      # Run salloc from the login node to get an interactive shell on a compute node
      salloc --partition=accel --gpus=a100_80:1 --ntasks=1 --cpus-per-task=32 --mem-per-cpu=4G --time=00:30:00 --qos=devel --account=ecXXX

      .. NOTE::

         The high ``--cpus-per-task=32`` value speeds up compilation. For inference-only runs, it can be reduced to 8 without affecting throughput. A lower value also tends to allocate resources faster (less waiting time).
      module purge
      module load CUDA/12.8.0 CMake/4.0.3-GCCcore-14.3.0 Python
      mkdir -p ~/llm-inference && cd ~/llm-inference

      # Create Python environment (cached after first run)
      if [ ! -d "vllm-env" ]; then
         python3 -m venv vllm-env
         source vllm-env/bin/activate
         pip install "vllm>=0.27.0"
      else
         source vllm-env/bin/activate
      fi

      # Start the vLLM inference server
      vllm serve unsloth/Qwen3.8-27B-GGUF \
         --served-model-name qwen3.8-27b \
         --trust-remote-code \
         --tensor-parallel-size 1 \
         --max-model-len 262144 \
         --port 55000 \
         --quantization fp8 \
         --gpu-memory-utilization 0.95 \
         --max-num-batched-tokens 32768 \
         --enable-chunked-prefill

      # Chat via curl (stream mode)
      curl -N http://127.0.0.1:55000/v1/chat/completions \
         -H "Content-Type: application/json" \
         -d '{"model":"qwen3.8-27b","messages":[{"role":"user","content":"Hello"}],"max_tokens":50,"stream":true}'

   .. NOTE::

      Interactive jobs stop when you log out from the login node. Use ``tmux`` to keep the session alive across disconnects:

      .. code-block:: console

         ssh -l ec-[username] fox.educloud.no
         tmux
         salloc --partition=accel --gpus=a100_80:1 --ntasks=1 --cpus-per-task=32 --mem-per-cpu=4G --time=00:30:00 --qos=devel --account=ecXXX
         # ... start vllm serve & curl ...
         exit
         tmux detach (Ctrl-B then D)

      Reconnect later with ``tmux attach`` from the login node.

2. Batch mode (sbatch)

   For non-interactive usage, create a Slurm job script:

   .. code-block:: console

      cat > qwen38-vllm-job.sh << 'EOF'
      #!/bin/bash
      #SBATCH --job-name=qwen38-vllm
      #SBATCH --partition=accel
      #SBATCH --account=ecXXX
      #SBATCH --gpus=a100_80:1
      #SBATCH --ntasks-per-node=1
      #SBATCH --cpus-per-task=32
      #SBATCH --mem-per-cpu=4G
      #SBATCH --time=00:30:00
      #SBATCH --output=slurm-%j.out
      #SBATCH --error=slurm-%j.err

      module purge
      module load CUDA/12.8.0 CMake/4.0.3-GCCcore-14.3.0 Python

      WORKDIR=$HOME/llm-inference
      mkdir -p $WORKDIR
      cd $WORKDIR

      # Create Python environment (cached after first run)
      if [ ! -d "vllm-env" ]; then
         python3 -m venv vllm-env
         source vllm-env/bin/activate
         pip install "vllm>=0.27.0"
      else
         source vllm-env/bin/activate
      fi

      # Start the vLLM inference server
      vllm serve unsloth/Qwen3.8-27B-GGUF \
         --served-model-name qwen3.8-27b \
         --trust-remote-code \
         --tensor-parallel-size 1 \
         --max-model-len 262144 \
         --port 55000 \
         --quantization fp8 \
         --gpu-memory-utilization 0.95 \
         --max-num-batched-tokens 32768 \
         --enable-chunked-prefill

      echo "vLLM server running on port 55000"
      EOF

3. Submit the job

   .. code-block:: console

      chmod +x qwen38-vllm-job.sh
      sbatch qwen38-vllm-job.sh

4. Monitor the job

   .. code-block:: console

      squeue -u ec-[username]
      sstat -j <job-id>

5. Connect an agent framework to the inference server

   First, find the GPU node your job is running on (e.g. ``gpu-17``):

   .. code-block:: console

      squeue -u ec-[username]
      sstat -j <job-id>

   Create an SSH tunnel from your local machine or NREC instance to the GPU node. An SSH tunnel is always required when connecting from your agent framework:

   .. code-block:: console

      ssh -N -l ec-[username] fox.educloud.no -L 50000:[gpu-node]:55000

   .. NOTE::

      The server port (``55000``) may be in use by another user following this tutorial. Change it to an available port (e.g. ``56000``) in both the server startup command and the SSH tunnel.

   Configure your agent framework to use the local endpoint:

   .. code-block:: console

      # In your agent config:
      # provider: custom
      # endpoint: http://127.0.0.1:55000/v1

   .. WARNING::

      The inference server listens on ``0.0.0.0``, exposing it to all users with network access to the GPU node. Always use an SSH tunnel when connecting — do not expose the server directly.

   Test with curl (stream mode):

   .. code-block:: console

      curl -N http://127.0.0.1:55000/v1/chat/completions \
         -H "Content-Type: application/json" \
         -d '{"model":"qwen3.8-27b","messages":[{"role":"user","content":"Hello"}],"max_tokens":50,"stream":true}'

6. Stop the job

   When finished, stop the Slurm job:

   .. code-block:: console

      scancel <job-id>

   Or press ``Ctrl+C`` if the job is running interactively.

.. NOTE::

   Jobs are automatically terminated when the ``--time`` limit expires (``00:30:00`` by default). Save your work accordingly.

.. NOTE::

   - Fox GPU jobs are accounted per-GPU, not per-CPU. Requesting 6 GPUs costs 6× the rate.
   - Use ``--quantization fp8`` for FP8 quantization on A100.

Performance comparison
----------------------

The following table summarizes verified inference performance across all Qwen model tutorials. Benchmarks reflect tested throughput on NREC L40S (24 GB), Fox HPC A100 (80 GB), and Fox HPC A40 (48 GB) hardware.

.. table::
   :widths: auto

   +------------------------------+-----------------+---------+-------------+------------+--------------------------+----------------+------------------+
   | **Model**                    | **Quantization**| **Size**| **Platform**| **Backend**| **Throughput**           | **Reasoning**  | **Coding**       |
   +==============================+=================+=========+=============+============+==========================+================+==================+
   | `unsloth/Qwen3.6-35B-A3B-MTP-| UD-Q2_K_XL      | ~17 GB  | NREC L40S   | llama.cpp  | ~160-190 tok/s           | 5/6 correct    | 14/24 tests      |
   | GGUF`                        |                 |         | Half GPU +  |            |                          | ~655 tok/output| (drifts on       |
   |                              |                 |         | 16-core CPU |            |                          | ~2.8s reply    | constraints)     |
   +------------------------------+-----------------+---------+-------------+------------+--------------------------+----------------+------------------+
   | `zerodigest/Qwen3.8-27B-     | YMQ-M (IQ3_XXS) | ~14 GB  | Fox A100    | llama.cpp  | ~50-65 tok/s             | 6/6 correct    | 14/24 tests      |
   | Uncensored-YMQ-MTP-GGUF`     |                 |         | (80 GB)     |            |                          | ~97 tok/output | (budget exhausted|
   |                              |                 |         |             |            |                          | ~1.7s reply    | on coding tasks) |
   +------------------------------+-----------------+---------+-------------+------------+--------------------------+----------------+------------------+
   | `HauhauCS/Qwen3.8-27B-       | Q4_K_P +        | ~19 GB +| Fox A100    | llama.cpp  | ~50-65 tok/s             | 6/6 correct    | **24/30 tests**  |
   | Uncensored-HauhauCS-         | FastMTP sidecar | 903 MB  | (80 GB)     |            |                          | ~298 tok/output| (best agentic    |
   | Aggressive-MTP-GGUF`         |                 |         |             |            |                          | ~9.2s reply    | performance)     |
   +------------------------------+-----------------+---------+-------------+------------+--------------------------+----------------+------------------+
   | `unsloth/Qwen3.8-27B-GGUF`   | FP8             | ~28 GB  | Fox A100    | vLLM       | ~60-80 tok/s (unverified)| Not tested     | Not tested       |
   |                              |                 |         | (80 GB)     |            |                          |                |                  |
   +------------------------------+-----------------+---------+-------------+------------+--------------------------+----------------+------------------+

Key highlights:

- **Fastest throughput**: Qwen3.6-35B-A3B on NREC L40S (~160-190 tok/s), leveraging MTP speculative decoding on 24 GB VRAM
- **Second fastest**: vLLM with FP8 on A100 (~60-80 tok/s (unverified)), leveraging PagedAttention and continuous batching
- **Best for agentic tasks**: HauhauCS Q4_K_P with FastMTP sidecar (**24/30 coding tests**), up to 3.02x document throughput vs MTP disabled
- **Lowest VRAM**: zerodigest YMQ-M IQ3_XXS (~14 GB) fits comfortably on 24 GB L40S systems
- **Most token-efficient**: zerodigest YMQ-M IQ3_XXS (~97 mean output tokens, ~1.7s reply time) — 3.1× fewer tokens and ~5× faster than Q4_K_P




- **Maximum context**: All models support 262144 context length on 80 GB A100 and 48 GB A40 systems

- **Speculative decoding**: llama.cpp MTP and vLLM both enable significant speedups over baseline inference

References
==========

llama.cpp model selection
-------------------------

**Model 1**: `zerodigest/Qwen3.8-27B-Uncensored-YMQ-MTP-GGUF` with YMQ-M quantization (~14 GB).

The YMQ-M (Mixture of Quantizations) checkpoint includes the MTP (Multi-Token Prediction) speculative head, which enables draft-based speculative decoding in llama.cpp.

**Verified throughput**: ~50-65 tok/s on A100 80GB with ``--spec-type draft-mtp --spec-draft-n-max 2`` (1.3-1.5x speedup over baseline).

**Model 2**: `HauhauCS/Qwen3.8-27B-Uncensored-HauhauCS-Aggressive-MTP-GGUF` with Q4_K_P quantization (~19 GB) plus the HauhauCS FastMTP sidecar (903 MB).

The HauhauCS Aggressive variant provides direct answers with no refusal behavior. The Q4_K_P quantization fits A100 80GB and A40 48 GB systems while the embedded NextN head enables MTP. The separate FastMTP sidecar achieves up to 3.02x document throughput and 1.93x reasoning throughput versus MTP disabled — significantly higher than standard embedded MTP.

**Verified throughput**: ~50-65 tok/s on A100 80GB with FastMTP sidecar (up to 3.02x document throughput vs MTP disabled).

Key flags for both models: ``--cache-type-k q8_0 --cache-type-v q8_0`` optimizes KV cache memory, ``--ctx-size 262144`` uses the model's native maximum context length, and ``--chat-template-kwargs '{"preserve_thinking":true}'`` adds extra reasoning tokens that improve the model's reasoning quality.

vLLM model selection
--------------------

**Model**: `unsloth/Qwen3.8-27B-GGUF` with FP8 quantization (~28 GB) served through vLLM.

The A100 is an Ampere-architecture GPU with native FP8 Tensor Core support. The FP8 quantized checkpoint runs efficiently on A100's FP8 cores, delivering significant speedup over BF16 while using only ~28 GB VRAM (half of BF16's ~56 GB), leaving substantially more room for KV cache at 262K context.

Benchmark context: Qwen3.8-27B FP8 with vLLM on single A100 GPU estimated ~60-80 tok/s generation (unverified), outperforming llama.cpp by ~1.2-1.5x through continuous batching and PagedAttention. FP8 quantization also reduces KV memory by ~50%, enabling longer effective context windows.

Note: Throughput figures (~50-65 tok/s for llama.cpp, ~60-80 tok/s for vLLM) are measured on A100 80GB. A40 48GB throughput will be lower due to reduced VRAM and bandwidth.

vLLM's day-0 Qwen3.8 support leverages PagedAttention and continuous batching. The ``--quantization fp8`` flag enables FP8 model loading, further improving throughput. The FP8 checkpoint delivers near-BF16 quality with FP8-level speed, making it the optimal choice for A100 single-GPU inference.



// AMD Cauldron code
// 
// Copyright(c) 2023 Advanced Micro Devices, Inc.All rights reserved.
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files(the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sub-license, and / or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions :
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
#pragma once

#if defined(_DX12)

#include "render/rootsignature.h"
#include "agilitysdk/include/d3d12.h"
#include "dxheaders/include/directx/d3dx12.h"

#include <wrl.h>

namespace cauldron
{
    class RootSignatureInternal final : public RootSignature
    {
    public:
        const ID3D12RootSignature* DX12RootSignature() const { return m_pRootSignature.Get(); }
        ID3D12RootSignature* DX12RootSignature() { return m_pRootSignature.Get(); }

        RootSignatureInternal* GetImpl() override { return this; }
        const RootSignatureInternal* GetImpl() const override { return this; }

    private:
        friend class RootSignature;
        RootSignatureInternal(const wchar_t* name);
        virtual ~RootSignatureInternal() = default;

        void Build(const RootSignatureDesc& desc) override;

    private:

        // Internal members
        Microsoft::WRL::ComPtr<ID3D12RootSignature> m_pRootSignature = nullptr;
    };

} // namespace cauldron

#endif // #if defined(_DX12)

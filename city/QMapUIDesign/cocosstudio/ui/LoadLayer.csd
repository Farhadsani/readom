<GameProjectFile>
  <PropertyGroup Type="Layer" Name="LoadLayer" ID="abb6a959-7527-4efd-ab74-ae2989f8d381" Version="2.0.6.0" />
  <Content ctype="GameProjectContent">
    <Content>
      <Animation Duration="0" Speed="1.0000" />
      <ObjectData Name="Layer" FrameEvent="" Tag="90" ctype="LayerObjectData">
        <Position X="0.0000" Y="0.0000" />
        <Scale ScaleX="1.0000" ScaleY="1.0000" />
        <AnchorPoint />
        <CColor A="255" R="255" G="255" B="255" />
        <Size X="1080.0000" Y="1920.0000" />
        <PrePosition X="0.0000" Y="0.0000" />
        <PreSize X="0.0000" Y="0.0000" />
        <Children>
          <NodeObjectData Name="pnlBackGround" ActionTag="107539066" FrameEvent="" Tag="91" ObjectIndex="1" TouchEnable="True" ComboBoxIndex="1" ColorAngle="90.0000" ctype="PanelObjectData">
            <Position X="0.0000" Y="0.0000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <AnchorPoint />
            <CColor A="255" R="255" G="255" B="255" />
            <Size X="1080.0000" Y="1920.0000" />
            <PrePosition X="0.0000" Y="0.0000" />
            <PreSize X="1.0000" Y="1.0000" />
            <Children>
              <NodeObjectData Name="sp2" ActionTag="-520393395" FrameEvent="" Tag="8" ObjectIndex="5" ctype="SpriteObjectData">
                <Position X="0.0000" Y="364.8000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <AnchorPoint ScaleY="0.5000" />
                <CColor A="255" R="255" G="255" B="255" />
                <Size X="1628.0000" Y="113.0000" />
                <PrePosition X="0.0000" Y="0.1900" />
                <PreSize X="0.0000" Y="0.0000" />
                <FileData Type="Normal" Path="ui/image/loadSP2.png" />
              </NodeObjectData>
              <NodeObjectData Name="sp3" ActionTag="390025844" FrameEvent="" Tag="11" ObjectIndex="7" ctype="SpriteObjectData">
                <Position X="1628.0000" Y="364.8000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <AnchorPoint ScaleY="0.5000" />
                <CColor A="255" R="255" G="255" B="255" />
                <Size X="1628.0000" Y="113.0000" />
                <PrePosition X="1.5074" Y="0.1900" />
                <PreSize X="0.0000" Y="0.0000" />
                <FileData Type="Normal" Path="ui/image/loadSP2.png" />
              </NodeObjectData>
              <NodeObjectData Name="sp1" ActionTag="-980556081" FrameEvent="" Tag="11" ObjectIndex="1" IconVisible="True" PrePositionEnabled="True" ctype="ProjectNodeObjectData">
                <Position X="540.0000" Y="425.6640" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <AnchorPoint />
                <CColor A="255" R="255" G="255" B="255" />
                <Size X="0.0000" Y="0.0000" />
                <PrePosition X="0.5000" Y="0.2217" />
                <PreSize X="0.0000" Y="0.0000" />
                <FileData Type="Normal" Path="ui/LoadAni.csd" />
              </NodeObjectData>
              <NodeObjectData Name="pnlLoading" ActionTag="135467955" FrameEvent="" Tag="14" ObjectIndex="2" TouchEnable="True" BackColorAlpha="102" ColorAngle="90.0000" ctype="PanelObjectData">
                <Position X="540.0000" Y="963.3333" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <CColor A="255" R="255" G="255" B="255" />
                <Size X="1080.0000" Y="200.0000" />
                <PrePosition X="0.5000" Y="0.5017" />
                <PreSize X="1.0000" Y="0.1042" />
                <Children>
                  <NodeObjectData Name="loadingBar" ActionTag="-779082569" FrameEvent="" Tag="9" ObjectIndex="1" PrePositionEnabled="True" ProgressInfo="84" ctype="LoadingBarObjectData">
                    <Position X="540.0000" Y="100.0000" />
                    <Scale ScaleX="2.0000" ScaleY="1.5000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <CColor A="255" R="253" G="220" B="67" />
                    <Size X="414.0000" Y="30.0000" />
                    <PrePosition X="0.5000" Y="0.5000" />
                    <PreSize X="0.0000" Y="0.0000" />
                    <ImageFileData Type="Normal" Path="ui/image/loadingbarbk.png" />
                  </NodeObjectData>
                  <NodeObjectData Name="Text_1" ActionTag="894934954" FrameEvent="" Tag="15" ObjectIndex="1" PrePositionEnabled="True" FontSize="48" LabelText="Loading..." HorizontalAlignmentType="HT_Center" VerticalAlignmentType="VT_Center" ctype="TextObjectData">
                    <Position X="540.0000" Y="160.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <CColor A="255" R="0" G="0" B="0" />
                    <Size X="210.0000" Y="54.0000" />
                    <PrePosition X="0.5000" Y="0.8000" />
                    <PreSize X="0.0000" Y="0.0000" />
                  </NodeObjectData>
                  <NodeObjectData Name="txtPercent" ActionTag="-9662784" FrameEvent="" Tag="16" ObjectIndex="2" PrePositionEnabled="True" FontSize="48" LabelText="0%" HorizontalAlignmentType="HT_Center" VerticalAlignmentType="VT_Center" ctype="TextObjectData">
                    <Position X="540.0000" Y="40.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <CColor A="255" R="0" G="0" B="0" />
                    <Size X="69.0000" Y="54.0000" />
                    <PrePosition X="0.5000" Y="0.2000" />
                    <PreSize X="0.0000" Y="0.0000" />
                  </NodeObjectData>
                </Children>
                <SingleColor A="255" R="150" G="200" B="255" />
                <FirstColor A="255" R="150" G="200" B="255" />
                <EndColor A="255" R="255" G="255" B="255" />
                <ColorVector ScaleY="1.0000" />
              </NodeObjectData>
            </Children>
            <SingleColor A="255" R="242" G="239" B="224" />
            <FirstColor A="255" R="242" G="239" B="224" />
            <EndColor A="255" R="255" G="255" B="255" />
            <ColorVector ScaleY="1.0000" />
          </NodeObjectData>
        </Children>
      </ObjectData>
    </Content>
  </Content>
</GameProjectFile>